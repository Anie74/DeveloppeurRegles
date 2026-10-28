Class {
	#name : 'ExpertComplexityThresholdRule',
	#superclass : 'ReExclusivelyExpertRule',
	#instVars : [
		'maxComplexity'
	],
	#category : 'Renraku-Rules',
	#package : 'Renraku',
	#tag : 'Rules'
}

{ #category : 'accessing' }
ExpertComplexityThresholdRule class >> ruleName [
    ^ 'Complexité de contrôle trop élevée'
]

{ #category : 'manifest' }
ExpertComplexityThresholdRule class >> uniqueIdentifierName [
    ^ 'ComplexityThreshold'
]

{ #category : 'checking' }
ExpertComplexityThresholdRule >> checkMethod: aMethod [
    | complexity |
    complexity := self complexityOf: aMethod.
    complexity > maxComplexity ifTrue: [
        ^ { self
            newCritiqueFor: aMethod
            hint: 'Complexité cyclomatique de ', complexity printString,
                ' (maximum ', maxComplexity printString, ')' } ].
    ^ #()
]

{ #category : 'analysis' }
ExpertComplexityThresholdRule >> complexityOf: aMethod [
    | decisions |
    decisions := 0.
    aMethod ast nodesDo: [ :node |
        (node isMessage and: [ self decisionSelectors includes: node selector ])
            ifTrue: [ decisions := decisions + 1 ] ].
    ^ decisions + 1
]

{ #category : 'accessing' }
ExpertComplexityThresholdRule >> decisionSelectors [
    ^ #(#ifTrue: #ifFalse: #ifTrue:ifFalse: #ifFalse:ifTrue:
        #ifNil: #ifNotNil: #ifNil:ifNotNil: #ifNotNil:ifNil:
        #and: #or: #whileTrue: #whileFalse: #whileTrue #whileFalse
        #to:do: #to:by:do: #timesRepeat:)
]

{ #category : 'accessing' }
ExpertComplexityThresholdRule >> group [
    ^ 'Conception avancée'
]

{ #category : 'initialization' }
ExpertComplexityThresholdRule >> initialize [
    super initialize.
    maxComplexity := 10
]

{ #category : 'accessing' }
ExpertComplexityThresholdRule >> maxComplexity [
    ^ maxComplexity
]

{ #category : 'accessing' }
ExpertComplexityThresholdRule >> maxComplexity: anInteger [
    maxComplexity := anInteger
]

{ #category : 'accessing' }
ExpertComplexityThresholdRule >> name [
    ^ 'Complexité de contrôle trop élevée'
]

{ #category : 'accessing' }
ExpertComplexityThresholdRule >> rationale [
    ^ 'Une complexité cyclomatique élevée rend la méthode difficile à comprendre et à tester : découpez-la'
]

{ #category : 'accessing' }
ExpertComplexityThresholdRule >> severity [
    ^ #warning
]
