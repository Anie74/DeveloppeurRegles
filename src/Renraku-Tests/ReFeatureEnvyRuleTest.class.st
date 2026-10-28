Class {
	#name : 'ReFeatureEnvyRuleTest',
	#superclass : 'ReExclusivelyExpertRuleTest',
	#category : 'Renraku-Tests-Rules',
	#package : 'Renraku-Tests',
	#tag : 'Rules'
}

{ #category : 'tests' }
ReFeatureEnvyRuleTest >> testDetectEnvyOfAnArgument [
    | critiques |
    TestBooleanClass compile: 'testMethod: other
        other first.
        other second.
        other third.
        other fourth.
        other fifth.
        ^ self hash'.
    critiques := ReFeatureEnvyRule new
        checkMethod: (TestBooleanClass >> #testMethod:).
    self assert: critiques size equals: 1.
    self assert: (critiques first tinyHint includesSubstring: 'other')
]

{ #category : 'tests' }
ReFeatureEnvyRuleTest >> testNoCritiqueForFewMessages [
    | critiques |
    TestBooleanClass compile: 'testMethod: other
        other first.
        other second.
        other third.
        ^ 1'.
    critiques := ReFeatureEnvyRule new
        checkMethod: (TestBooleanClass >> #testMethod:).
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReFeatureEnvyRuleTest >> testNoCritiqueForTemporaryVariable [
    | critiques |
    TestBooleanClass compile: 'testMethod: other
        | stream |
        stream := OrderedCollection new.
        stream add: 1.
        stream add: 2.
        stream add: 3.
        stream add: 4.
        stream add: 5.
        ^ stream'.
    critiques := ReFeatureEnvyRule new
        checkMethod: (TestBooleanClass >> #testMethod:).
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReFeatureEnvyRuleTest >> testNoCritiqueWhenSelfIsUsedMore [
    | critiques |
    TestBooleanClass compile: 'testMethod: other
        other first.
        other second.
        other third.
        other fourth.
        other fifth.
        self one.
        self two.
        self three.
        self four.
        self five.
        self six.
        ^ 1'.
    critiques := ReFeatureEnvyRule new
        checkMethod: (TestBooleanClass >> #testMethod:).
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReFeatureEnvyRuleTest >> testRuleMetadata [
    | rule |
    rule := ReFeatureEnvyRule new.
    self assert: rule severity equals: #warning.
    self assert: rule group equals: 'Conception avancée'.
    self deny: rule name isEmpty.
    self deny: rule rationale isEmpty.
    self assert: rule class uniqueIdentifierName equals: 'FeatureEnvy'
]
