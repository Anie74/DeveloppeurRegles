"
Detect unused temporary variable
"
Class {
	#name : 'ReUnusedTemporaryRule',
	#superclass : 'ReExclusivelyIntermediateRule',
	#category : 'Renraku-Rules',
	#package : 'Renraku',
	#tag : 'Rules'
}

{ #category : 'accessing' }
ReUnusedTemporaryRule class >> ruleName [
    ^ 'Temporary variable unused'
]

{ #category : 'manifest' }
ReUnusedTemporaryRule class >> uniqueIdentifierName [
    ^ 'UnusedTemporary'
]

{ #category : 'checking' }
ReUnusedTemporaryRule >> checkMethod: aMethod [
    | critiques source |
    critiques := OrderedCollection new.
    source := aMethod sourceCode.
    aMethod ast body temporaries do: [ :temp |
        (self countWord: temp name in: source) <= 1 ifTrue: [
            critiques add: (self
                newCritiqueFor: aMethod
                hint: 'Unused temporary variable : ', temp name) ] ].
    ^ critiques

]

{ #category : 'accessing' }
ReUnusedTemporaryRule >> group [
    ^ 'Intermediate level errors'


]

{ #category : 'accessing' }
ReUnusedTemporaryRule >> name [
    ^ 'Temporary variable unused'


]

{ #category : 'accessing' }
ReUnusedTemporaryRule >> rationale [
    ^ 'An unused temporary variable must be deleted'


]

{ #category : 'accessing' }
ReUnusedTemporaryRule >> severity [
    ^ #warning
]
