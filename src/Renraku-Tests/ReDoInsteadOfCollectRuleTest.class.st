Class {
	#name : 'ReDoInsteadOfCollectRuleTest',
	#superclass : 'ReExclusivelyIntermediateRuleTest',
	#category : 'Renraku-Tests-Rules',
	#package : 'Renraku-Tests',
	#tag : 'Rules'
}

{ #category : 'tests' }
ReDoInsteadOfCollectRuleTest >> testDetectDoWithAdd [
    | critiques |
    TestBooleanClass compile: 'testMethod
        | result |
        result := OrderedCollection new.
        #(1 2 3) do: [ :each | result add: each * 2 ].
        ^ result'.
    critiques := ReDoInsteadOfCollectRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques size equals: 1.
    self assert: (critiques first tinyHint includesSubstring: 'collect:')

]

{ #category : 'tests' }
ReDoInsteadOfCollectRuleTest >> testNoCritiqueForCollect [
    | critiques |
    TestBooleanClass compile: 'testMethod
        ^ #(1 2 3) collect: [ :each | each * 2 ]'.
    critiques := ReDoInsteadOfCollectRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReDoInsteadOfCollectRuleTest >> testNoCritiqueForDoWithOtherMessage [
    | critiques |
    TestBooleanClass compile: 'testMethod
        #(1 2 3) do: [ :each | each printString ].
        ^ 1'.
    critiques := ReDoInsteadOfCollectRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReDoInsteadOfCollectRuleTest >> testNoCritiqueForDoWithSeveralStatements [
    | critiques |
    TestBooleanClass compile: 'testMethod
        | result |
        result := OrderedCollection new.
        #(1 2 3) do: [ :each |
            result add: each.
            result size ].
        ^ result'.
    critiques := ReDoInsteadOfCollectRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReDoInsteadOfCollectRuleTest >> testRuleMetadata [
    | rule |
    rule := ReDoInsteadOfCollectRule new.
    self assert: rule severity equals: #warning.
    self assert: rule group equals: 'Intermediate errors rule'.
    self deny: rule name isEmpty.
    self deny: rule rationale isEmpty.
    self assert: rule class uniqueIdentifierName equals: 'DoInsteadOfCollect'
]
