"
'c isEmpty ifTrue: [...]' ou 'c notEmpty ifTrue: [...]' : les collections offrent `ifEmpty:` et `ifNotEmpty:`.

"
Class {
	#name : 'ReIsEmptyWithIfTrueRule',
	#superclass : 'ReExclusivelyIntermediateRule',
	#category : 'Renraku-Rules',
	#package : 'Renraku',
	#tag : 'Rules'
}

{ #category : 'accessing' }
ReIsEmptyWithIfTrueRule class >> ruleName [
    ^ 'isEmpty ou notEmpty avec ifTrue:'
]

{ #category : 'manifest' }
ReIsEmptyWithIfTrueRule class >> uniqueIdentifierName [
    ^ 'IsEmptyWithIfTrue'
]
