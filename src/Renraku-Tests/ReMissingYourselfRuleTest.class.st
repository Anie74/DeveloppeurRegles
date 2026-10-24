Class {
	#name : 'ReMissingYourselfRuleTest',
	#superclass : 'ReExclusivelyIntermediateRuleTest',
	#category : 'Renraku-Tests-Rules',
	#package : 'Renraku-Tests',
	#tag : 'Rules'
}

{ #category : 'tests' }
ReMissingYourselfRuleTest >> testDetectAssignedCascade [
    | critiques |
    TestBooleanClass compile: 'testMethod
        | c |
        c := OrderedCollection new add: 1; add: 2.
        ^ c'.
    critiques := ReMissingYourselfRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques size equals: 1.
    self assert: (critiques first tinyHint includesSubstring: 'yourself')
]

{ #category : 'tests' }
ReMissingYourselfRuleTest >> testDetectReturnedCascade [
    | critiques |
    TestBooleanClass compile: 'testMethod
        ^ OrderedCollection new add: 1; add: 2'.
    critiques := ReMissingYourselfRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques size equals: 1
]

{ #category : 'tests' }
ReMissingYourselfRuleTest >> testNoCritiqueForCascadeAsStatement [
    | critiques |
    TestBooleanClass compile: 'testMethod
        | c |
        c := OrderedCollection new.
        c add: 1; add: 2.
        ^ c'.
    critiques := ReMissingYourselfRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReMissingYourselfRuleTest >> testNoCritiqueWithYourself [
    | critiques |
    TestBooleanClass compile: 'testMethod
        ^ OrderedCollection new add: 1; add: 2; yourself'.
    critiques := ReMissingYourselfRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReMissingYourselfRuleTest >> testRuleMetadata [
    | rule |
    rule := ReMissingYourselfRule new.
    self assert: rule severity equals: #warning.
    self assert: rule group equals: 'Erreurs intermédiaire'.
    self deny: rule name isEmpty.
    self deny: rule rationale isEmpty.
    self assert: rule class uniqueIdentifierName equals: 'MissingYourself'
]
