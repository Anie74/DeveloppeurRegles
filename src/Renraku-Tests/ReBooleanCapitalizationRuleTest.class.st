Class {
	#name : 'ReBooleanCapitalizationRuleTest',
	#superclass : 'ReExclusivelyBeginnersRuleTest',
	#category : 'Renraku-Tests-Rules',
	#package : 'Renraku-Tests',
	#tag : 'Rules'
}

{ #category : 'tests' }
ReBooleanCapitalizationRuleTest >> testDetectFalse [
    | critiques |
    TestBooleanClass compile: 'testMethod
        ^ False'.
    critiques := ReBooleanCapitalizationRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques size equals: 1.
    self assert: (critiques first tinyHint includesSubstring: 'false')
]

{ #category : 'tests' }
ReBooleanCapitalizationRuleTest >> testDetectMultiple [
    | critiques |
    TestBooleanClass compile: 'testMethod
        | Nil |
        True ifTrue: [ ^ False ].
        ^ Nil'.
    critiques := ReBooleanCapitalizationRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques size equals: 3
]

{ #category : 'tests' }
ReBooleanCapitalizationRuleTest >> testDetectNil [
    | critiques |
    TestBooleanClass compile: 'testMethod
        | Nil |
        ^ Nil'.
    critiques := ReBooleanCapitalizationRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques size equals: 1.
    self assert: (critiques first tinyHint includesSubstring: 'nil')
]

{ #category : 'tests' }
ReBooleanCapitalizationRuleTest >> testDetectTrue [
    | critiques |
    TestBooleanClass compile: 'testMethod
        ^ True'.
    critiques := ReBooleanCapitalizationRule new 
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques size equals: 1.
    self assert: (critiques first tinyHint includesSubstring: 'true')
]

{ #category : 'tests' }
ReBooleanCapitalizationRuleTest >> testNoFalsePositives [
    | critiques |
    TestBooleanClass compile: 'testMethod
        true ifTrue: [ ^ false ].
        ^ nil'.
    critiques := ReBooleanCapitalizationRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques isEmpty
]
