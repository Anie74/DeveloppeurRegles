Class {
	#name : 'NoobTest',
	#superclass : 'ReExclusivelyBeginnersRuleTest',
	#category : 'Renraku-Tests-Rules',
	#package : 'Renraku-Tests',
	#tag : 'Rules'
}

{ #category : 'tests' }
NoobTest >> testDetectAllErrors [
    | critiques |
    TestBooleanClass compile: 'testMethod
        | Nil Self return |
        "ifTrue[ ifFalse[ && ||"
        True ifTrue: [ ^ False ].
        ^ Nil'.
    critiques := Noob new
        checkMethod: (TestBooleanClass >> #testMethod).
    "True, False, Nil, Self, return, ifTrue[, ifFalse[, &&, ||"
    self assert: critiques size equals: 9
]

{ #category : 'tests' }
NoobTest >> testHintMentionsCorrection [
    | critiques |
    TestBooleanClass compile: 'testMethod
        ^ True'.
    critiques := Noob new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques size equals: 1.
    self assert: (critiques first tinyHint includesSubstring: 'true')
]

{ #category : 'tests' }
NoobTest >> testNoFalsePositives [
    | critiques |
    TestBooleanClass compile: 'testMethod
        true ifTrue: [ ^ false ].
        ^ nil'.
    critiques := Noob new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques isEmpty
]

{ #category : 'tests' }
NoobTest >> testRuleMetadata [
    | rule |
    rule := Noob new.
    self assert: rule severity equals: #error.
    self assert: rule group equals: 'Erreurs débutant'.
    self deny: rule name isEmpty.
    self deny: rule rationale isEmpty.
    self assert: rule class uniqueIdentifierName equals: 'NoobRule'
]
