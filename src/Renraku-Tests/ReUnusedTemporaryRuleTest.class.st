Class {
	#name : 'ReUnusedTemporaryRuleTest',
	#superclass : 'TestCase',
	#category : 'Renraku-Tests-Rules',
	#package : 'Renraku-Tests',
	#tag : 'Rules'
}

{ #category : 'tests' }
ReUnusedTemporaryRuleTest >> testDetectTwoUnusedTemporaries [
    | critiques |
    TestBooleanClass compile: 'testMethod
        | first second |
        ^ 1'.
    critiques := ReUnusedTemporaryRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques size equals: 2

]

{ #category : 'tests' }
ReUnusedTemporaryRuleTest >> testDetectUnusedTemporary [
    | critiques |
    TestBooleanClass compile: 'testMethod
        | a unused |
        a := 5.
        ^ a'.
    critiques := ReUnusedTemporaryRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques size equals: 1.
    self assert: (critiques first tinyHint includesSubstring: 'unused')
]

{ #category : 'tests' }
ReUnusedTemporaryRuleTest >> testNoCritiqueWhenAllUsed [
    | critiques |
    TestBooleanClass compile: 'testMethod
        | a |
        a := 5.
        ^ a'.
    critiques := ReUnusedTemporaryRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReUnusedTemporaryRuleTest >> testNoCritiqueWithoutTemporaries [
    | critiques |
    TestBooleanClass compile: 'testMethod
        ^ 1'.
    critiques := ReUnusedTemporaryRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReUnusedTemporaryRuleTest >> testRuleMetadata [
    | rule |
    rule := ReUnusedTemporaryRule new.
    self assert: rule severity equals: #warning.
    self assert: rule group equals: 'Erreurs intermédiaire'.
    self deny: rule name isEmpty.
    self deny: rule rationale isEmpty.
    self assert: rule class uniqueIdentifierName equals: 'UnusedTemporary'

]
