"
More than 5 temporary variables: it's too much.

"
Class {
	#name : 'ReTooManyTemporariesRule',
	#superclass : 'ReExclusivelyIntermediateRule',
	#category : 'Renraku-Rules',
	#package : 'Renraku',
	#tag : 'Rules'
}

{ #category : 'accessing' }
ReTooManyTemporariesRule class >> ruleName [
    ^ 'Trop de variables temporaires'
]

{ #category : 'manifest' }
ReTooManyTemporariesRule class >> uniqueIdentifierName [
    ^ 'TooManyTemporaries'
]

{ #category : 'checking' }
ReTooManyTemporariesRule >> checkMethod: aMethod [
    aMethod ast body temporaries size > 5 ifTrue: [
        ^ { self
            newCritiqueFor: aMethod
            hint: 'Plus de 5 variables temporaires : découpez la méthode' } ].
    ^ #()
]

{ #category : 'accessing' }
ReTooManyTemporariesRule >> group [
    ^ 'Erreurs intermédiaire'
]

{ #category : 'accessing' }
ReTooManyTemporariesRule >> name [
    ^ 'Trop de variables temporaires'
]

{ #category : 'accessing' }
ReTooManyTemporariesRule >> rationale [
    ^ 'Une méthode avec plus de 5 variables temporaires est probablement trop complexe'

]

{ #category : 'accessing' }
ReTooManyTemporariesRule >> severity [
    ^ #warning
]
