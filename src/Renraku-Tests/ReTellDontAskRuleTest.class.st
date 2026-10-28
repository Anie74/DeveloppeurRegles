Class {
	#name : 'ReTellDontAskRuleTest',
	#superclass : 'ReExclusivelyExpertRuleTest',
	#category : 'Renraku-Tests-Rules',
	#package : 'Renraku-Tests',
	#tag : 'Rules'
}

{ #category : 'tests' }
ReTellDontAskRuleTest >> testDetectAskThenTell [
    | critiques |
    TestBooleanClass compile: 'testMethod: aCollection
        aCollection isEmpty ifTrue: [ aCollection add: 1 ].
        ^ aCollection'.
    critiques := ReTellDontAskRule new
        checkMethod: (TestBooleanClass >> #testMethod:).
    self assert: critiques size equals: 1.
    self assert: (critiques first tinyHint includesSubstring: 'aCollection')
]

{ #category : 'tests' }
ReTellDontAskRuleTest >> testNoCritiqueForComparisons [
    | critiques |
    TestBooleanClass compile: 'testMethod: x
        x > 0 ifTrue: [ x > 1 ifTrue: [ ^ 1 ] ].
        ^ 0'.
    critiques := ReTellDontAskRule new
        checkMethod: (TestBooleanClass >> #testMethod:).
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReTellDontAskRuleTest >> testNoCritiqueForMessageWithoutArgument [
    | critiques |
    TestBooleanClass compile: 'testMethod: aCollection
        aCollection isEmpty ifTrue: [ aCollection reset ].
        ^ aCollection'.
    critiques := ReTellDontAskRule new
        checkMethod: (TestBooleanClass >> #testMethod:).
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReTellDontAskRuleTest >> testNoCritiqueForQuestionsAskedToSelf [
    | critiques |
    TestBooleanClass compile: 'testMethod: aCollection
        self isEmpty ifTrue: [ self add: 1 ].
        ^ aCollection'.
    critiques := ReTellDontAskRule new
        checkMethod: (TestBooleanClass >> #testMethod:).
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReTellDontAskRuleTest >> testNoCritiqueWhenBranchIgnoresTheObject [
    | critiques |
    TestBooleanClass compile: 'testMethod: aCollection
        aCollection isEmpty ifTrue: [ ^ 0 ].
        ^ 1'.
    critiques := ReTellDontAskRule new
        checkMethod: (TestBooleanClass >> #testMethod:).
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReTellDontAskRuleTest >> testRuleMetadata [
    | rule |
    rule := ReTellDontAskRule new.
    self assert: rule severity equals: #warning.
    self assert: rule group equals: 'Conception avancée'.
    self deny: rule name isEmpty.
    self deny: rule rationale isEmpty.
    self assert: rule class uniqueIdentifierName equals: 'TellDontAsk'
]
