Class {
	#name : 'ReOrOperatorRuleTest',
	#superclass : 'ReExclusivelyBeginnersRuleTest',
	#category : 'Renraku-Tests-Rules',
	#package : 'Renraku-Tests',
	#tag : 'Rules'
}

{ #category : 'tests' }
ReOrOperatorRuleTest >> testDetectDoublePipe [
    | critiques |
    TestBooleanClass compile: 'testMethod
        "a || false"
        ^ 1'.
    critiques := ReOrOperatorRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques size equals: 1.
    self assert: (critiques first tinyHint includesSubstring: 'or:')
]

{ #category : 'tests' }
ReOrOperatorRuleTest >> testNoFalsePositives [
    | critiques |
    TestBooleanClass compile: 'testMethod
        | a |
        a := false.
        ^ a or: [ true ]'.
    critiques := ReOrOperatorRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReOrOperatorRuleTest >> testRuleMetadata [
    | rule |
    rule := ReOrOperatorRule new.
    self assert: rule severity equals: #error.
    self assert: rule group equals: 'Erreurs débutant'.
    self deny: rule name isEmpty.
    self deny: rule rationale isEmpty.
    self assert: rule class uniqueIdentifierName equals: 'OrOperator'
]
