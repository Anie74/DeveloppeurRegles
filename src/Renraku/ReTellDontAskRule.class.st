Class {
	#name : 'ReTellDontAskRule',
	#superclass : 'ReExclusivelyExpertRule',
	#category : 'Renraku-Rules',
	#package : 'Renraku',
	#tag : 'Rules'
}

{ #category : 'accessing' }
ReTellDontAskRule class >> ruleName [
    ^ 'Tell, don''t ask'
]

{ #category : 'manifest' }
ReTellDontAskRule class >> uniqueIdentifierName [
    ^ 'TellDontAsk'
]

{ #category : 'private' }
ReTellDontAskRule >> askedVariableOf: aConditionalNode [
    | condition |
    condition := aConditionalNode receiver.
    ^ (condition isMessage and: [
        condition arguments isEmpty and: [
            condition receiver isVariable and: [ condition receiver name ~= 'self' ] ] ])
        ifTrue: [ condition receiver name ]
        ifFalse: [ nil ]
]

{ #category : 'checking' }
ReTellDontAskRule >> checkMethod: aMethod [
    | critiques |
    critiques := OrderedCollection new.
    aMethod ast nodesDo: [ :node |
        (node isMessage and: [
            #(#ifTrue: #ifFalse: #ifTrue:ifFalse: #ifFalse:ifTrue:) includes: node selector ])
            ifTrue: [
                | asked |
                asked := self askedVariableOf: node.
                (asked notNil and: [ self tells: asked inBlocksOf: node ])
                    ifTrue: [
                        critiques add: (self
                            newCritiqueFor: aMethod
                            hint: 'Tell, don''t ask : demandez à ', asked, ' de faire le travail') ] ] ].
    ^ critiques
]

{ #category : 'accessing' }
ReTellDontAskRule >> group [
    ^ 'Conception avancée'
]

{ #category : 'accessing' }
ReTellDontAskRule >> name [
    ^ 'Tell, don''t ask'
]

{ #category : 'accessing' }
ReTellDontAskRule >> rationale [
    ^ 'Ne demandez pas son état à un objet pour décider à sa place : demandez-lui de faire le travail'
]

{ #category : 'accessing' }
ReTellDontAskRule >> severity [
    ^ #warning
]

{ #category : 'private' }
ReTellDontAskRule >> tells: aName inBlocksOf: aConditionalNode [
    aConditionalNode arguments do: [ :argument |
        argument isBlock ifTrue: [
            argument nodesDo: [ :inner |
                (inner isMessage and: [
                    inner arguments notEmpty and: [
                        inner selector first isLetter and: [
                            inner receiver isVariable and: [ inner receiver name = aName ] ] ] ])
                    ifTrue: [ ^ true ] ] ] ].
    ^ false
]
