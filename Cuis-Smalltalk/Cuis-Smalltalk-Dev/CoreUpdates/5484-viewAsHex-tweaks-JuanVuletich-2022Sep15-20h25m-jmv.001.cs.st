'From Cuis 6.0 [latest update: #5483] on 16 September 2022 at 8:17:55 am'!

!FileList methodsFor: 'private' stamp: 'jmv 9/15/2022 20:28:22'!
readContentsHex: brevity
	"retrieve the contents from the external file unless it is too long.
	  Don't create a file here.  Check if exists."
	| size data hexData firstPartSize |
	firstPartSize _ 1e3.
	directory // fileName readStreamDo: [ :stream |
		stream ifNil: [^ 'For some reason, this file cannot be read'].
		stream useBytes.
		((size _ stream size)) > (10*firstPartSize) & brevity
			ifTrue: [ data _ stream next: firstPartSize. brevityState := #briefHex ]
			ifFalse: [ data _ stream next: size. brevityState := #fullHex ]].

	hexData _ String streamContents: [ :s |
		0 to: data size-1 by: 16 do: [ :loc |
			loc printOn: s base: 16 length: 8 padded: true.
			s
				space;
				nextPut: $(.
			loc printOn: s base: 10 length: 10 padded: true.
			s
				nextPut: $);
				space;
				tab.
			loc+1 to: (loc+16 min: data size) do: [ :i | s nextPutAll: (Character numericValue: (data at: i)) hex; space ].
			s newLine ]].

	^ acceptedContentsCache _ ((size > (10*firstPartSize)) & brevity
		ifTrue: ['File ''{1}'' is {2} bytes long.
You may use the ''get'' command to read the entire file.

Here are the first {3} characters...
------------------------------------------
{4}
------------------------------------------
... end of the first {3} characters.' format: {fileName. size. firstPartSize. hexData}]
		ifFalse: [hexData])! !

