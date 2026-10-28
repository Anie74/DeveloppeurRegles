Class {
	#name : 'ReLongParameterListRule',
	#superclass : 'ReExclusivelyExpertRule',
	#category : 'Renraku-Rules',
	#package : 'Renraku',
	#tag : 'Rules'
}

{ #category : 'accessing' }
ReLongParameterListRule class >> ruleName [
    ^ 'Liste de paramètres trop longue'
]

{ #category : 'manifest' }
ReLongParameterListRule class >> uniqueIdentifierName [
    ^ 'LongParameterList'
]

{ #category : 'checking' }
ReLongParameterListRule >> checkMethod: aMethod [
    aMethod numArgs > self maxArguments ifTrue: [
        ^ { self
            newCritiqueFor: aMethod
            hint: 'Méthode à ', aMethod numArgs printString, ' paramètres (maximum ',
                self maxArguments printString, ') : introduisez un objet paramètre' } ].
    ^ #()
]

{ #category : 'accessing' }
ReLongParameterListRule >> group [
    ^ 'Conception avancée'
]

{ #category : 'accessing' }
ReLongParameterListRule >> maxArguments [
    ^ 4
]

{ #category : 'accessing' }
ReLongParameterListRule >> name [
    ^ 'Liste de paramètres trop longue'
]

{ #category : 'accessing' }
ReLongParameterListRule >> rationale [
    ^ 'Plus de 4 paramètres indiquent qu''un objet paramètre ou un découpage de la méthode est nécessaire'
]

{ #category : 'accessing' }
ReLongParameterListRule >> severity [
    ^ #warning
]
