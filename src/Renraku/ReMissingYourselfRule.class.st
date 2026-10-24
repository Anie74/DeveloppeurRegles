"
Detect the missing yourself from cascading methods
"
Class {
	#name : 'ReMissingYourselfRule',
	#superclass : 'ReExclusivelyIntermediateRule',
	#category : 'Renraku-Rules',
	#package : 'Renraku',
	#tag : 'Rules'
}

{ #category : 'accessing' }
ReMissingYourselfRule class >> ruleName [
    ^ 'Cascade sans yourself'
]

{ #category : 'manifest' }
ReMissingYourselfRule class >> uniqueIdentifierName [
    ^ 'MissingYourself'
]

{ #category : 'checking' }
ReMissingYourselfRule >> checkMethod: aMethod [
    | critiques |
    critiques := OrderedCollection new.
    aMethod ast nodesDo: [ :node |
        (node isCascade and: [
            node parent notNil and: [
                node parent isAssignment or: [ node parent isReturn ] ] ])
            ifTrue: [
                node messages last selector = #yourself ifFalse: [
                    critiques add: (self
                        newCritiqueFor: aMethod
                        hint: 'Terminez la cascade par yourself pour obtenir le receveur') ] ] ].
    ^ critiques
]

{ #category : 'accessing' }
ReMissingYourselfRule >> group [
    ^ 'Erreurs intermédiaire'
]

{ #category : 'accessing' }
ReMissingYourselfRule >> name [
    ^ 'Cascade sans yourself'
]

{ #category : 'accessing' }
ReMissingYourselfRule >> rationale [
    ^ 'Une cascade assignée ou retournée sans yourself renvoie la réponse du dernier message, pas le receveur'
]

{ #category : 'accessing' }
ReMissingYourselfRule >> severity [
    ^ #warning
]
