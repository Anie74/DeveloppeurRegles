Class {
	#name : 'ReExplicitBooleanComparisonRuleTest',
	#superclass : 'ReExclusivelyIntermediateRule',
	#category : 'Renraku-Tests',
	#package : 'Renraku-Tests'
}

{ #category : 'tests' }
ReExplicitBooleanComparisonRuleTest >> testDetectEqualsTrue [
    | critiques |
    TestBooleanClass compile: 'testMethod
        | x |
        x := true.
        ^ x = true'.
    critiques := ReExplicitBooleanComparisonRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques size equals: 1
]

{ #category : 'tests' }
ReExplicitBooleanComparisonRuleTest >> testDetectIdenticalFalse [
    | critiques |
    TestBooleanClass compile: 'testMethod
        | x |
        x := true.
        ^ x == false'.
    critiques := ReExplicitBooleanComparisonRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques size equals: 1
]
