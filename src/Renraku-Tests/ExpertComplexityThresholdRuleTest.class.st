Class {
	#name : 'ExpertComplexityThresholdRuleTest',
	#superclass : 'ReExclusivelyExpertRuleTest',
	#category : 'Renraku-Tests-Rules',
	#package : 'Renraku-Tests',
	#tag : 'Rules'
}

{ #category : 'tests' }
ExpertComplexityThresholdRuleTest >> methodWithDecisions: anInteger [
    "Source d'une méthode ayant anInteger points de décision"
    ^ String streamContents: [ :stream |
        stream nextPutAll: 'testMethod: x'; cr.
        1 to: anInteger do: [ :i |
            stream
                nextPutAll: '    x > ';
                print: i;
                nextPutAll: ' ifTrue: [ ^ ';
                print: i;
                nextPutAll: ' ].';
                cr ].
        stream nextPutAll: '    ^ 0' ]
]

{ #category : 'tests' }
ExpertComplexityThresholdRuleTest >> testBooleanOperatorsCount [
    | method |
    TestBooleanClass compile: 'testMethod: x
        ^ x > 0 and: [ x < 10 or: [ x = 20 ] ]'.
    method := TestBooleanClass >> #testMethod:.
    self assert: (ExpertComplexityThresholdRule new complexityOf: method) equals: 3
]

{ #category : 'tests' }
ExpertComplexityThresholdRuleTest >> testConfigurableThreshold [
    | rule critiques |
    TestBooleanClass compile: 'testMethod: x
        x > 0 ifTrue: [ ^ 1 ].
        x < 0 ifTrue: [ ^ 2 ].
        ^ 0'.
    rule := ExpertComplexityThresholdRule new.
    rule maxComplexity: 2.
    critiques := rule checkMethod: (TestBooleanClass >> #testMethod:).
    self assert: critiques size equals: 1
]

{ #category : 'tests' }
ExpertComplexityThresholdRuleTest >> testDefaultThreshold [
    self assert: ExpertComplexityThresholdRule new maxComplexity equals: 10
]

{ #category : 'tests' }
ExpertComplexityThresholdRuleTest >> testDetectHighComplexity [
    | critiques |
    "10 décisions = complexité 11"
    TestBooleanClass compile: (self methodWithDecisions: 10).
    critiques := ExpertComplexityThresholdRule new
        checkMethod: (TestBooleanClass >> #testMethod:).
    self assert: critiques size equals: 1.
    self assert: (critiques first tinyHint includesSubstring: '11')
]

{ #category : 'tests' }
ExpertComplexityThresholdRuleTest >> testLoopsCount [
    | method |
    TestBooleanClass compile: 'testMethod: x
        1 to: x do: [ :i | i > 2 ifTrue: [ ^ i ] ].
        ^ 0'.
    method := TestBooleanClass >> #testMethod:.
    self assert: (ExpertComplexityThresholdRule new complexityOf: method) equals: 3
]

{ #category : 'tests' }
ExpertComplexityThresholdRuleTest >> testNoCritiqueAtTheLimit [
    | critiques |
    "9 décisions = complexité 10"
    TestBooleanClass compile: (self methodWithDecisions: 9).
    critiques := ExpertComplexityThresholdRule new
        checkMethod: (TestBooleanClass >> #testMethod:).
    self assert: critiques isEmpty
]

{ #category : 'tests' }
ExpertComplexityThresholdRuleTest >> testRuleMetadata [
    | rule |
    rule := ExpertComplexityThresholdRule new.
    self assert: rule severity equals: #warning.
    self assert: rule group equals: 'Conception avancée'.
    self deny: rule name isEmpty.
    self deny: rule rationale isEmpty.
    self assert: rule class uniqueIdentifierName equals: 'ComplexityThreshold'
]

{ #category : 'tests' }
ExpertComplexityThresholdRuleTest >> testSimpleMethodHasComplexityOne [
    | method |
    TestBooleanClass compile: 'testMethod: x
        ^ x'.
    method := TestBooleanClass >> #testMethod:.
    self assert: (ExpertComplexityThresholdRule new complexityOf: method) equals: 1
]
