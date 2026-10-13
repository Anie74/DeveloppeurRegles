Class {
	#name : 'ReIfTrueColonRuleTest',
	#superclass : 'ReExclusivelyBeginnersRuleTest',
	#category : 'Renraku-Tests-Rules',
	#package : 'Renraku-Tests',
	#tag : 'Rules'
}

{ #category : 'tests' }
ReIfTrueColonRuleTest >> testDetectBoth [
    | critiques |
    TestBooleanClass compile: 'testMethod
        "ifTrue[ ifFalse["
        ^ 1'.
    critiques := ReIfTrueColonRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques size equals: 2
]

{ #category : 'tests' }
ReIfTrueColonRuleTest >> testDetectIfFalseWithoutColon [
    | critiques |
    TestBooleanClass compile: 'testMethod
        "x ifFalse[ ^ 0 ]"
        ^ 1'.
    critiques := ReIfTrueColonRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques size equals: 1.
    self assert: (critiques first tinyHint includesSubstring: 'ifFalse:')

]

{ #category : 'tests' }
ReIfTrueColonRuleTest >> testDetectIfTrueWithoutColon [
    | critiques |
    TestBooleanClass compile: 'testMethod
        "x ifTrue[ ^ 1 ]"
        ^ 1'.
    critiques := ReIfTrueColonRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques size equals: 1.
    self assert: (critiques first tinyHint includesSubstring: 'ifTrue:')
]

{ #category : 'tests' }
ReIfTrueColonRuleTest >> testNoFalsePositives [
    | critiques |
    TestBooleanClass compile: 'testMethod
        true ifTrue: [ ^ 1 ] ifFalse: [ ^ 0 ]'.
    critiques := ReIfTrueColonRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReIfTrueColonRuleTest >> testRuleMetadata [
    | rule |
    rule := ReIfTrueColonRule new.
    self assert: rule severity equals: #error.
    self assert: rule group equals: 'Erreurs débutant'.
    self deny: rule name isEmpty.
    self deny: rule rationale isEmpty.
    self assert: rule class uniqueIdentifierName equals: 'IfTrueColon'
]
