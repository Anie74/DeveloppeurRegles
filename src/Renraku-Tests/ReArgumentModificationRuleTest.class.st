Class {
	#name : 'ReArgumentModificationRuleTest',
	#superclass : 'ReExclusivelyExpertRuleTest',
	#category : 'Renraku-Tests-Rules',
	#package : 'Renraku-Tests',
	#tag : 'Rules'
}

{ #category : 'tests' }
ReArgumentModificationRuleTest >> testDetectAddOnArgument [
    | critiques |
    TestBooleanClass compile: 'testMethod: aCollection
        aCollection add: 42'.
    critiques := ReArgumentModificationRule new
        checkMethod: (TestBooleanClass >> #testMethod:).
    self assert: critiques size equals: 1.
    self assert: (critiques first tinyHint includesSubstring: 'aCollection')
]

{ #category : 'tests' }
ReArgumentModificationRuleTest >> testDetectAtPutOnArgument [
    | critiques |
    TestBooleanClass compile: 'testMethod: anArray
        anArray at: 1 put: 0'.
    critiques := ReArgumentModificationRule new
        checkMethod: (TestBooleanClass >> #testMethod:).
    self assert: critiques size equals: 1
]

{ #category : 'tests' }
ReArgumentModificationRuleTest >> testNoCritiqueForCopy [
    | critiques |
    TestBooleanClass compile: 'testMethod: aCollection
        ^ aCollection copy add: 42; yourself'.
    critiques := ReArgumentModificationRule new
        checkMethod: (TestBooleanClass >> #testMethod:).
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReArgumentModificationRuleTest >> testNoCritiqueForModifiedTemporary [
    | critiques |
    TestBooleanClass compile: 'testMethod: aCollection
        | result |
        result := OrderedCollection new.
        result add: aCollection size.
        ^ result'.
    critiques := ReArgumentModificationRule new
        checkMethod: (TestBooleanClass >> #testMethod:).
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReArgumentModificationRuleTest >> testNoCritiqueForReadOnlyUse [
    | critiques |
    TestBooleanClass compile: 'testMethod: aCollection
        ^ aCollection size'.
    critiques := ReArgumentModificationRule new
        checkMethod: (TestBooleanClass >> #testMethod:).
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReArgumentModificationRuleTest >> testRuleMetadata [
    | rule |
    rule := ReArgumentModificationRule new.
    self assert: rule severity equals: #warning.
    self assert: rule group equals: 'Conception avancée'.
    self deny: rule name isEmpty.
    self deny: rule rationale isEmpty.
    self assert: rule class uniqueIdentifierName equals: 'ArgumentModification'
]
