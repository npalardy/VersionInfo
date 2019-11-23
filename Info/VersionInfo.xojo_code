#tag Class
Protected Class VersionInfo
	#tag Method, Flags = &h1
		Protected Sub Constructor()
		  #If TargetMacOS
		    macOSInfo
		  #ElseIf TargetWindows
		    windowsInfo
		  #ElseIf TargetLinux
		    linuxInfo
		  #ElseIf TargetIOS
		    iOSInfo
		  #EndIf
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub iOSInfo()
		  // wrapped just to make sure this code doesnt try to get compiled on other targets
		  #If TargetIOS
		    Break
		  #EndIf
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub linuxInfo()
		  // wrapped just to make sure this code doesnt try to get compiled on other targets
		  #If TargetLinux
		    Break
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub macOSInfo()
		  // wrapped just to make sure this code doesnt try to get compiled on other targets
		  #If TargetMacOS
		    Break
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub windowsInfo()
		  // wrapped just to make sure this code doesnt try to get compiled on other targets
		  #If TargetWindows
		    Break
		  #EndIf
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return m_Major
			End Get
		#tag EndGetter
		Major As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return m_Minor
			End Get
		#tag EndGetter
		Minor As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected m_Major As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected m_Minor As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected m_Patch As Integer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return m_Patch
			End Get
		#tag EndGetter
		Patch As Integer
	#tag EndComputedProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Major"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Minor"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Patch"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
