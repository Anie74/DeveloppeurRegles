Class {
	#name : 'ReIsNilWithIfTrueRuleTest',
	#superclass : 'ReExclusivelyIntermediateRuleTest',
	#category : 'Renraku-Tests-Rules',
	#package : 'Renraku-Tests',
	#tag : 'Rules'
}

{ #category : 'tests' }
ReIsNilWithIfTrueRuleTest >> testDetectIsNilIfTrue [
    | critiques |
    TestBooleanClass compile: 'testMethod
        | x |
        x := nil.
        x isNil ifTrue: [ ^ 1 ].
        ^ 0'.
    critiques := ReIsNilWithIfTrueRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques size equals: 1.
    self assert: (critiques first tinyHint includesSubstring: 'ifNil:')

]

{ #category : 'tests' }
ReIsNilWithIfTrueRuleTest >> testDetectNotNilIfTrue [
    | critiques |
    TestBooleanClass compile: 'testMethod
        | x |
        x := nil.
        x notNil ifTrue: [ ^ 1 ].
        ^ 0'.
    critiques := ReIsNilWithIfTrueRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques size equals: 1
]

{ #category : 'tests' }
ReIsNilWithIfTrueRuleTest >> testNoCritiqueForIfNil [
    | critiques |
    TestBooleanClass compile: 'testMethod
        | x |
        x := nil.
        x ifNil: [ ^ 1 ].
        ^ 0'.
    critiques := ReIsNilWithIfTrueRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReIsNilWithIfTrueRuleTest >> testNoCritiqueForIsNilAlone [
    | critiques |
    TestBooleanClass compile: 'testMethod
        | x |
        x := nil.
        ^ x isNil'.
    critiques := ReIsNilWithIfTrueRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques isEmpty

]

{ #category : 'tests' }
ReIsNilWithIfTrueRuleTest >> testRuleMetadata [
    | rule |
    rule := ReIsNilWithIfTrueRule new.
    self assert: rule severity equals: #warning.
    self assert: rule group equals: 'Erreurs intermédiaire'.
    self deny: rule name isEmpty.
    self deny: rule rationale isEmpty.
    self assert: rule class uniqueIdentifierName equals: 'IsNilWithIfTrue'
]
