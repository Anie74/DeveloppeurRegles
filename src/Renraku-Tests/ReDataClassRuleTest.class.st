Class {
	#name : 'ReDataClassRuleTest',
	#superclass : 'ReExclusivelyExpertRuleTest',
	#category : 'Renraku-Tests-Rules',
	#package : 'Renraku-Tests',
	#tag : 'Rules'
}

{ #category : 'tests' }
ReDataClassRuleTest >> testDetectClassMadeOfAccessors [
    | critiques |
    TestDataSandbox compile: 'first
        ^ first'.
    TestDataSandbox compile: 'first: anObject
        first := anObject'.
    TestDataSandbox compile: 'second
        ^ second'.
    TestDataSandbox compile: 'second: anObject
        second := anObject'.
    critiques := ReDataClassRule new checkClass: TestDataSandbox.
    #(#first #first: #second #second:) do: [ :each |
        TestDataSandbox removeSelector: each ].
    self assert: critiques size equals: 1.
    self assert: (critiques first tinyHint includesSubstring: 'accesseurs')
]

{ #category : 'tests' }
ReDataClassRuleTest >> testNoCritiqueForSmallClass [
    | critiques |
    TestDataSandbox compile: 'first
        ^ first'.
    TestDataSandbox compile: 'first: anObject
        first := anObject'.
    TestDataSandbox compile: 'second
        ^ second'.
    critiques := ReDataClassRule new checkClass: TestDataSandbox.
    #(#first #first: #second) do: [ :each |
        TestDataSandbox removeSelector: each ].
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReDataClassRuleTest >> testNoCritiqueWhenThereIsBehavior [
    | critiques |
    TestDataSandbox compile: 'first
        ^ first'.
    TestDataSandbox compile: 'compute
        ^ first + second'.
    TestDataSandbox compile: 'describe
        ^ first printString'.
    TestDataSandbox compile: 'total
        ^ second + 1'.
    critiques := ReDataClassRule new checkClass: TestDataSandbox.
    #(#first #compute #describe #total) do: [ :each |
        TestDataSandbox removeSelector: each ].
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReDataClassRuleTest >> testRuleMetadata [
    | rule |
    rule := ReDataClassRule new.
    self assert: rule severity equals: #warning.
    self assert: rule group equals: 'Architecture'.
    self deny: rule name isEmpty.
    self deny: rule rationale isEmpty.
    self assert: rule class uniqueIdentifierName equals: 'DataClass'
]
