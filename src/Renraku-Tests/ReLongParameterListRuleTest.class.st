Class {
	#name : 'ReLongParameterListRuleTest',
	#superclass : 'ReExclusivelyExpertRuleTest',
	#category : 'Renraku-Tests-Rules',
	#package : 'Renraku-Tests',
	#tag : 'Rules'
}

{ #category : 'tests' }
ReLongParameterListRuleTest >> testDetectFiveParameters [
    | critiques |
    TestBooleanClass compile: 'first: a second: b third: c fourth: d fifth: e
        ^ a'.
    critiques := ReLongParameterListRule new
        checkMethod: (TestBooleanClass >> #first:second:third:fourth:fifth:).
    TestBooleanClass removeSelector: #first:second:third:fourth:fifth:.
    self assert: critiques size equals: 1.
    self assert: (critiques first tinyHint includesSubstring: 'objet paramètre')
]

{ #category : 'tests' }
ReLongParameterListRuleTest >> testNoCritiqueForFourParameters [
    | critiques |
    TestBooleanClass compile: 'first: a second: b third: c fourth: d
        ^ a'.
    critiques := ReLongParameterListRule new
        checkMethod: (TestBooleanClass >> #first:second:third:fourth:).
    TestBooleanClass removeSelector: #first:second:third:fourth:.
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReLongParameterListRuleTest >> testNoCritiqueWithoutParameters [
    | critiques |
    TestBooleanClass compile: 'testMethod
        ^ 1'.
    critiques := ReLongParameterListRule new
        checkMethod: (TestBooleanClass >> #testMethod).
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ReLongParameterListRuleTest >> testRuleMetadata [
    | rule |
    rule := ReLongParameterListRule new.
    self assert: rule severity equals: #warning.
    self assert: rule group equals: 'Conception avancée'.
    self deny: rule name isEmpty.
    self deny: rule rationale isEmpty.
    self assert: rule class uniqueIdentifierName equals: 'LongParameterList'
]
