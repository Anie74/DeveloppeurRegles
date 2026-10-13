Class {
	#name : 'ReAndOperatorRuleTest',
	#superclass : 'ReExclusivelyBeginnersRuleTest',
	#category : 'Renraku-Tests-Rules',
	#package : 'Renraku-Tests',
	#tag : 'Rules'
}

{ #category : 'tests' }
ReAndOperatorRuleTest >> testDetectDoubleAmpersand [
    | critiques |
    TestBooleanClass compile: 'testMethod
        "a && true"
        ^ 1'.
    critiques := ReAndOperatorRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques size equals: 1.
    self assert: (critiques first tinyHint includesSubstring: 'and:')
]

{ #category : 'tests' }
ReAndOperatorRuleTest >> testNoFalsePositives [
    | critiques |
    TestBooleanClass compile: 'testMethod
        | a |
        a := true.
        ^ a and: [ true ]'.
    critiques := ReAndOperatorRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReAndOperatorRuleTest >> testRuleMetadata [
    | rule |
    rule := ReAndOperatorRule new.
    self assert: rule severity equals: #error.
    self assert: rule group equals: 'Erreurs débutant'.
    self deny: rule name isEmpty.
    self deny: rule rationale isEmpty.
    self assert: rule class uniqueIdentifierName equals: 'AndOperator'
]
