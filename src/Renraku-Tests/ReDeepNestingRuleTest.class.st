Class {
	#name : 'ReDeepNestingRuleTest',
	#superclass : 'ReExclusivelyExpertRuleTest',
	#category : 'Renraku-Tests-Rules',
	#package : 'Renraku-Tests',
	#tag : 'Rules'
}

{ #category : 'tests' }
ReDeepNestingRuleTest >> testDetectFourLevels [
    | critiques |
    TestBooleanClass compile: 'testMethod: x
        x > 0 ifTrue: [
            x > 1 ifTrue: [
                x > 2 ifTrue: [
                    x > 3 ifTrue: [ ^ 1 ] ] ] ].
        ^ 0'.
    critiques := ReDeepNestingRule new
        checkMethod: (TestBooleanClass >> #testMethod:).
    self assert: critiques size equals: 1.
    self assert: (critiques first tinyHint includesSubstring: '4')
]

{ #category : 'tests' }
ReDeepNestingRuleTest >> testNoCritiqueForFlatMethod [
    | critiques |
    TestBooleanClass compile: 'testMethod: x
        x > 0 ifTrue: [ ^ 1 ].
        x > 1 ifTrue: [ ^ 2 ].
        x > 2 ifTrue: [ ^ 3 ].
        x > 3 ifTrue: [ ^ 4 ].
        ^ 0'.
    critiques := ReDeepNestingRule new
        checkMethod: (TestBooleanClass >> #testMethod:).
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReDeepNestingRuleTest >> testNoCritiqueForThreeLevels [
    | critiques |
    TestBooleanClass compile: 'testMethod: x
        x > 0 ifTrue: [
            x > 1 ifTrue: [
                x > 2 ifTrue: [ ^ 1 ] ] ].
        ^ 0'.
    critiques := ReDeepNestingRule new
        checkMethod: (TestBooleanClass >> #testMethod:).
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReDeepNestingRuleTest >> testRuleMetadata [
    | rule |
    rule := ReDeepNestingRule new.
    self assert: rule severity equals: #warning.
    self assert: rule group equals: 'Conception avancée'.
    self deny: rule name isEmpty.
    self deny: rule rationale isEmpty.
    self assert: rule class uniqueIdentifierName equals: 'DeepNesting'
]
