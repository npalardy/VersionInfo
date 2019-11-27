#tag Window
Begin Window Window1
   BackColor       =   &cFFFFFF00
   Backdrop        =   0
   CloseButton     =   True
   Compatibility   =   ""
   Composite       =   False
   Frame           =   0
   FullScreen      =   False
   FullScreenButton=   False
   HasBackColor    =   False
   Height          =   400
   ImplicitInstance=   True
   LiveResize      =   True
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   True
   MaxWidth        =   32000
   MenuBar         =   2050682879
   MenuBarVisible  =   True
   MinHeight       =   64
   MinimizeButton  =   True
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   True
   Title           =   "Untitled"
   Visible         =   True
   Width           =   600
   Begin TextArea TextArea1
      AcceptTabs      =   False
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   True
      BackColor       =   &cFFFFFF00
      Bold            =   False
      Border          =   True
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   360
      HelpTag         =   ""
      HideSelection   =   True
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LimitText       =   0
      LineHeight      =   0.0
      LineSpacing     =   1.0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Mask            =   ""
      Multiline       =   True
      ReadOnly        =   False
      Scope           =   0
      ScrollbarHorizontal=   False
      ScrollbarVertical=   True
      Styled          =   True
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   20
      Transparent     =   False
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   560
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Open()
		  TestOSVersionInfo
		  
		  TestLibraryVersionInfo
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h1
		Protected Sub TestLibraryDoesNotExist()
		  // =====================================================
		  // =====================================================
		  // just so I can introduce a new scope level for testing
		  If True Then
		    
		    // lets try a file that does not exist or has no version info to it
		    Dim versionInfo As Info.VersionInfo 
		    Dim f As folderitem 
		    
		    f = New folderitem( "/Users/npalardy/Desktop/RB Test Projects/Doesnt Exist Test.xojo_binary_project ", folderitem.PathTypeNative ) // get the version info for this dll dylib etc
		    versionInfo = Info.LibraryVersionInfo(f)
		    
		    // using the factory method this 
		    // can be NIL if the version info cannot be found
		    If versionInfo <> Nil Then
		      TextArea1.AppendText f.NativePath + " version = " + Str(versionInfo.Major) + "." + Str(versionInfo.Minor) + "." + Str(versionInfo.patch) + EndOfLine
		      If versionInfo IsA Info.LibVersionInfo Then
		        Break
		      End If
		    End If
		  End If
		  // =====================================================
		  
		  
		  // =====================================================
		  // =====================================================
		  // just so I can introduce a new scope level for testing
		  If True Then
		    
		    // lets try a file that does not exist or has no version info to it
		    Dim versionInfo As Info.VersionInfo 
		    Dim f As folderitem 
		    
		    f = New folderitem( "/Users/npalardy/Desktop/RB Test Projects/Doesnt Exist Test.xojo_binary_project ", folderitem.PathTypeNative ) // get the version info for this dll dylib etc
		    Try
		      // using the constructor this cannot be nil BUT
		      // it can throw an exception !
		      
		      versionInfo = New Info.LibVersionInfo(f)
		      
		      TextArea1.AppendText f.NativePath + " version = " + Str(versionInfo.Major) + "." + Str(versionInfo.Minor) + "." + Str(versionInfo.patch) + EndOfLine
		      If versionInfo IsA Info.LibVersionInfo Then
		        Break
		      End If
		    Catch unsupported As UnsupportedOperationException
		      Break
		    End Try
		    
		  End If
		  // =====================================================
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub TestLibraryExists()
		  // =====================================================
		  // =====================================================
		  // just so I can introduce a new scope level for testing
		  If True Then
		    Dim versionInfo As Info.VersionInfo 
		    Dim f As folderitem 
		    #If targetMacOS
		      f = New folderitem( "/usr/lib/libssl.dylib", folderitem.PathTypeNative ) // get the version info for this dylib 
		    #ElseIf TargetWindows
		      f = New folderitem( "C:\Windows\twain.dll", folderitem.PathTypeNative ) // get the version info for this dll 
		    #Else
		      ?
		    #EndIf
		    
		    versionInfo = Info.LibraryVersionInfo(f)
		    
		    If versionInfo <> Nil Then
		      TextArea1.AppendText f.NativePath + " version = " + Str(versionInfo.Major) + "." + Str(versionInfo.Minor) + "." + Str(versionInfo.patch) + EndOfLine
		      If versionInfo IsA Info.LibVersionInfo Then
		        Break
		      End If
		    End If
		  End If
		  // =====================================================
		  
		  
		  
		  // =====================================================
		  // =====================================================
		  // just so I can introduce a new scope level for testing
		  If True Then
		    Dim versionInfo As Info.VersionInfo 
		    Dim f As folderitem 
		    #If targetMacOS
		      f = New folderitem( "/usr/lib/libssl.dylib", folderitem.PathTypeNative ) // get the version info for this dylib 
		    #ElseIf TargetWindows
		      f = New folderitem( "C:\Windows\twain.dll", folderitem.PathTypeNative ) // get the version info for this dll 
		    #Else
		      ?
		    #EndIf
		    
		    // note you can use the constructor OR the factory method
		    // either will work
		    versionInfo = New Info.LibVersionInfo(f)
		    
		    If versionInfo <> Nil Then
		      TextArea1.AppendText f.NativePath + " version = " + Str(versionInfo.Major) + "." + Str(versionInfo.Minor) + "." + Str(versionInfo.patch) + EndOfLine
		      If versionInfo IsA Info.LibVersionInfo Then
		        Break
		      End If
		    End If
		  End If
		  // =====================================================
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub TestLibraryVersionInfo()
		  TestLibraryExists
		  
		  TestLibraryDoesNotExist
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub TestOSVersionInfo()
		  // =====================================================
		  // =====================================================
		  // just so I can introduce a new scope level for testing
		  If True Then
		    Dim versionInfo As Info.VersionInfo 
		    versionInfo = Info.OSVersionInfo // get the OS version information using the factory method
		    
		    // ALL version info's have a major, minor, patch
		    If versionInfo <> Nil Then
		      TextArea1.AppendText "OS version = " + Str(versionInfo.Major) + "." + Str(versionInfo.Minor) + "." + Str(versionInfo.patch) + EndOfLine
		      If versionInfo IsA Info.OSVersionInfo Then
		        TextArea1.AppendText "Is Server = " + Str(Info.OSVersionInfo(versionInfo).IsServer) + EndOfLine
		      End If
		    End If
		    
		    Dim s As String = versionInfo
		    TextArea1.AppendText s + EndOfLine
		  End If
		  // =====================================================
		  
		  
		  
		  // =====================================================
		  // =====================================================
		  // just so I can introduce a new scope level for testing
		  If True Then
		    Dim versionInfo As Info.VersionInfo 
		    
		    versionInfo = New Info.OSVersionInfo // get the info using the constructor - either works
		    
		    // ALL version info's have a major, minor, patch
		    If versionInfo <> Nil Then
		      TextArea1.AppendText "OS version = " + Str(versionInfo.Major) + "." + Str(versionInfo.Minor) + "." + Str(versionInfo.patch) + EndOfLine
		      If versionInfo IsA Info.OSVersionInfo Then
		        TextArea1.AppendText "Is Server = " + Str(Info.OSVersionInfo(versionInfo).IsServer) + EndOfLine
		      End If
		    End If
		    
		    Dim s As String = versionInfo
		    TextArea1.AppendText s + EndOfLine
		  End If
		  // =====================================================
		  
		End Sub
	#tag EndMethod


#tag EndWindowCode

#tag ViewBehavior
	#tag ViewProperty
		Name="Name"
		Visible=true
		Group="ID"
		Type="String"
		EditorType="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Interfaces"
		Visible=true
		Group="ID"
		Type="String"
		EditorType="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Super"
		Visible=true
		Group="ID"
		Type="String"
		EditorType="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Width"
		Visible=true
		Group="Size"
		InitialValue="600"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Size"
		InitialValue="400"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinWidth"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinHeight"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaxWidth"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaxHeight"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Frame"
		Visible=true
		Group="Frame"
		InitialValue="0"
		Type="Integer"
		EditorType="Enum"
		#tag EnumValues
			"0 - Document"
			"1 - Movable Modal"
			"2 - Modal Dialog"
			"3 - Floating Window"
			"4 - Plain Box"
			"5 - Shadowed Box"
			"6 - Rounded Window"
			"7 - Global Floating Window"
			"8 - Sheet Window"
			"9 - Metal Window"
			"11 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Frame"
		InitialValue="Untitled"
		Type="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="CloseButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Resizeable"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreenButton"
		Visible=true
		Group="Frame"
		InitialValue="False"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Group="OS X (Carbon)"
		InitialValue="False"
		Type="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Group="OS X (Carbon)"
		InitialValue="0"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="LiveResize"
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Placement"
		Visible=true
		Group="Behavior"
		InitialValue="0"
		Type="Integer"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Parent Window"
			"2 - Main Screen"
			"3 - Parent Window Screen"
			"4 - Stagger"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackColor"
		Visible=true
		Group="Background"
		InitialValue="False"
		Type="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="BackColor"
		Visible=true
		Group="Background"
		InitialValue="&hFFFFFF"
		Type="Color"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Background"
		Type="Picture"
		EditorType="Picture"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Menus"
		Type="MenuBar"
		EditorType="MenuBar"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Visible=true
		Group="Deprecated"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
#tag EndViewBehavior
