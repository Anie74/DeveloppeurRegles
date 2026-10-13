Class {
	#name : 'ReReturnKeywordRuleTest',
	#superclass : 'ReExclusivelyBeginnersRuleTest',
	#category : 'Renraku-Tests-Rules',
	#package : 'Renraku-Tests',
	#tag : 'Rules'
}

{ #category : 'tests' }
ReReturnKeywordRuleTest >> testDetectReturn [
    | critiques |
    TestBooleanClass compile: 'testMethod
        | return |
        return := 42.
        ^ return'.
    critiques := ReReturnKeywordRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques size equals: 1.
    self assert: (critiques first tinyHint includesSubstring: '^')
]

{ #category : 'tests' }
ReReturnKeywordRuleTest >> testIgnoresLongerIdentifiers [
    | critiques |
    TestBooleanClass compile: 'testMethod
        | returnCode |
        returnCode := 42.
        ^ returnCode'.
    critiques := ReReturnKeywordRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReReturnKeywordRuleTest >> testNoFalsePositives [
    | critiques |
    TestBooleanClass compile: 'testMethod
        ^ 42'.
    critiques := ReReturnKeywordRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReReturnKeywordRuleTest >> testRuleMetadata [
    | rule |
    rule := ReReturnKeywordRule new.
    self assert: rule severity equals: #error.
    self assert: rule group equals: 'Erreurs débutant'.
    self deny: rule name isEmpty.
    self deny: rule rationale isEmpty.
    self assert: rule class uniqueIdentifierName equals: 'ReturnKeyword'
]
