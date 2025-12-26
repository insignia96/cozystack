// SPDX-License-Identifier: Apache-2.0

// Package sorting provides generic sorting utilities for registry resources.
package sorting

import (
	"slices"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// NameGetter is an interface for objects that have a Name.
type NameGetter interface {
	GetName() string
}

// NamespaceGetter is an interface for objects that have both Name and Namespace.
type NamespaceGetter interface {
	NameGetter
	GetNamespace() string
}

// ByName sorts a slice of objects by their Name in alphabetical order.
// Use this for cluster-scoped resources.
func ByName[T any, PT interface {
	*T
	NameGetter
}](items []T) {
	slices.SortFunc(items, func(a, b T) int {
		pa, pb := PT(&a), PT(&b)
		switch {
		case pa.GetName() < pb.GetName():
			return -1
		case pa.GetName() > pb.GetName():
			return 1
		}
		return 0
	})
}

// ByNamespacedName sorts a slice of objects by Namespace/Name in alphabetical order.
// Use this for namespace-scoped resources.
func ByNamespacedName[T any, PT interface {
	*T
	NamespaceGetter
}](items []T) {
	slices.SortFunc(items, func(a, b T) int {
		pa, pb := PT(&a), PT(&b)
		aKey := pa.GetNamespace() + "/" + pa.GetName()
		bKey := pb.GetNamespace() + "/" + pb.GetName()
		switch {
		case aKey < bKey:
			return -1
		case aKey > bKey:
			return 1
		}
		return 0
	})
}

// ObjectMetaWrapper wraps metav1.ObjectMeta to implement NamespaceGetter.
type ObjectMetaWrapper struct {
	metav1.ObjectMeta
}

// GetName returns the name.
func (o *ObjectMetaWrapper) GetName() string {
	return o.Name
}

// GetNamespace returns the namespace.
func (o *ObjectMetaWrapper) GetNamespace() string {
	return o.Namespace
}
