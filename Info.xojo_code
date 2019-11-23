#tag Module
Protected Module Info
	#tag Method, Flags = &h0
		Function LibraryVersionInfo(f as FolderItem) As Info.VersionInfo
		  
		  // if this is NOT a dll / dylib / .so then we should return NIL
		  // at least thats what I would do
		  Try
		    Return New Info.LibVersionInfo(f)
		  Catch unsupportedException As UnsupportedOperationException
		    Return Nil
		  End Try
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function OSVersionInfo() As Info.VersionInfo
		  Return New Info.OSVersionInfo
		End Function
	#tag EndMethod


	#tag Note, Name = About Windows Versions
		
		From https://docs.microsoft.com/en-ca/windows/win32/api/winnt/ns-winnt-osversioninfoexa
		
		Operating system           Version number    dwMajorVersion    dwMinorVersion    Other
		Windows 10                    10.0*              10                 0            OSVERSIONINFOEX.wProductType == VER_NT_WORKSTATION
		Windows Server 2016           10.0*              10                 0            OSVERSIONINFOEX.wProductType != VER_NT_WORKSTATION
		Windows 8.1                    6.3*               6                 3            OSVERSIONINFOEX.wProductType == VER_NT_WORKSTATION
		Windows Server 2012 R2         6.3*               6                 3            OSVERSIONINFOEX.wProductType != VER_NT_WORKSTATION
		Windows 8                      6.2                6                 2            OSVERSIONINFOEX.wProductType == VER_NT_WORKSTATION
		Windows Server 2012            6.2                6                 2            OSVERSIONINFOEX.wProductType != VER_NT_WORKSTATION
		Windows 7                      6.1                6                 1            OSVERSIONINFOEX.wProductType == VER_NT_WORKSTATION
		
	#tag EndNote


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
	#tag EndViewBehavior
End Module
#tag EndModule
