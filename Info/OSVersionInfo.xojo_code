#tag Class
Protected Class OSVersionInfo
Inherits Info.VersionInfo
	#tag Method, Flags = &h0
		Sub Constructor()
		  // Calling the overridden superclass constructor.
		  Super.Constructor
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub iOSInfo()
		  // wrapped just to make sure this code doesnt try to get compiled on other targets
		  #If TargetIOS
		    
		    Dim rValue As m_OSVersionInfo
		    
		    // --- We're using 10.10
		    Declare Function NSClassFromString Lib "Foundation" ( className As CFStringRef ) As Ptr
		    Declare Function processInfo Lib "Foundation" selector "processInfo" ( ClassRef As Ptr ) As Ptr
		    Dim myInfo As Ptr = processInfo( NSClassFromString( "NSProcessInfo" ) )
		    Declare Function operatingSystemVersion Lib "Foundation" selector "operatingSystemVersion" ( NSProcessInfo As Ptr ) As m_OSVersionInfo
		    rvalue = operatingSystemVersion( myInfo )
		    
		    Me.m_Major = rValue.major
		    Me.m_Minor = rValue.minor
		    Me.m_Patch = rValue.bug
		    
		    
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
		    
		    Dim rValue As m_OSVersionInfo
		    
		    // --- We're using 10.10
		    Declare Function NSClassFromString Lib "Foundation" ( className As CFStringRef ) As Ptr
		    Declare Function processInfo Lib "Foundation" selector "processInfo" ( ClassRef As Ptr ) As Ptr
		    Dim myInfo As Ptr = processInfo( NSClassFromString( "NSProcessInfo" ) )
		    Declare Function operatingSystemVersion Lib "Foundation" selector "operatingSystemVersion" ( NSProcessInfo As Ptr ) As m_OSVersionInfo
		    rvalue = operatingSystemVersion( myInfo )
		    
		    Me.m_Major = rValue.major
		    Me.m_Minor = rValue.minor
		    Me.m_Patch = rValue.bug
		    
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub windowsInfo()
		  // wrapped just to make sure this code doesnt try to get compiled on other targets
		  #If TargetWindows
		    
		    
		    // from https://docs.microsoft.com/en-ca/windows/win32/sysinfo/getting-the-system-version
		    // where it says
		    // To obtain the full version number for the operating system, call the GetFileVersionInfo function
		    // on one of the system DLLs, such as Kernel32.dll, then call VerQueryValue to obtain the 
		    // \\StringFileInfo\\\\ProductVersion subblock of the file version information.
		    
		    'DWORD GetFileVersionInfoSizeA(
		    'LPCSTR  lptstrFilename,
		    'LPDWORD lpdwHandle
		    ');
		    Soft Declare Function GetFileVersionInfoSizeW Lib "Api-ms-win-core-version-l1-1-0.dll"  ( lptstrFilename As WString, ByRef lpdwHandle As Ptr ) As UInt32
		    
		    'BOOL GetFileVersionInfoA(
		    'LPCSTR lptstrFilename,
		    'DWORD  dwHandle,
		    'DWORD  dwLen,
		    'LPVOID lpData
		    ');
		    Soft Declare Function GetFileVersionInfoW Lib "Api-ms-win-core-version-l1-1-0.dll" ( lptstrFilename As  WString, dwHandle As UInt32 , dwLen As UInt32, lpData As Ptr) As Int32
		    
		    'BOOL VerQueryValueA(
		    'LPCVOID pBlock,
		    'LPCSTR  lpSubBlock,
		    'LPVOID  *lplpBuffer,
		    'PUINT   puLen
		    ');
		    Soft Declare Function VerQueryValueW Lib "Api-ms-win-core-version-l1-1-0.dll" ( pBlock As Ptr,  lpSubBlock As WString, ByRef lplpBuffer As Ptr, ByRef puLen As UInt32) As Int32
		    
		    If System.IsFunctionAvailable("GetFileVersionInfoSizeW" , "Api-ms-win-core-version-l1-1-0.dll") _
		      And System.IsFunctionAvailable("GetFileVersionInfoW" , "Api-ms-win-core-version-l1-1-0.dll") _
		      And System.IsFunctionAvailable("VerQueryValueW" , "Api-ms-win-core-version-l1-1-0.dll") Then
		      
		      Dim lpdwHandle As Ptr
		      
		      // as recommended we should get the size first
		      Dim infoSize As UInt32 = GetFileVersionInfoSizeW("Kernel32.dll", lpdwHandle)
		      If infoSize = 0 Then
		        Break
		        Return
		      End If
		      
		      Dim dataBuffer As New MemoryBlock(infoSize)
		      
		      Dim result As Int32 = GetFileVersionInfoW ( "Kernel32.dll", 0, infoSize, dataBuffer) 
		      // returns <> 0 on success
		      If result = 0 Then
		        Break
		        Return
		      End If
		      
		      Dim  lplpBuffer As Ptr
		      Dim puLen As UInt32
		      result = VerQueryValueW( dataBuffer, "\",  lplpBuffer, puLen)
		      
		      // now wtf to get the data from the ptr ????
		      If result <> 0 Then
		        Dim mb As memoryblock = lplpBuffer
		        
		        Break
		      End If
		    Else
		      
		      
		      If System.IsFunctionAvailable( "GetVersionExW", "Kernel32" ) Then
		        Soft Declare Sub GetVersionExW Lib "Kernel32" ( info As Ptr )
		        
		        Dim info As m_WindowsOSVersionInfoEX
		        
		        info.dwOSVersionInfoSize = info.StringValue.LenB
		        
		        GetVersionExW( info )
		        
		        m_Major = info.dwMajorVersion
		        m_Minor = info.dwMinorVersion
		        m_Patch = info.dwBuildNumber
		        
		        'From https://docs.microsoft.com/en-ca/windows/win32/api/winnt/ns-winnt-osversioninfoexa
		        '
		        'Operating System           Version number    dwMajorVersion    dwMinorVersion    Other
		        'Windows 10                    10.0*              10                 0            OSVERSIONINFOEX.wProductType == VER_NT_WORKSTATION
		        'Windows Server 2016           10.0*              10                 0            OSVERSIONINFOEX.wProductType != VER_NT_WORKSTATION
		        'Windows 8.1                    6.3*               6                 3            OSVERSIONINFOEX.wProductType == VER_NT_WORKSTATION
		        'Windows Server 2012 R2         6.3*               6                 3            OSVERSIONINFOEX.wProductType != VER_NT_WORKSTATION
		        'Windows 8                      6.2                6                 2            OSVERSIONINFOEX.wProductType == VER_NT_WORKSTATION
		        'Windows Server 2012            6.2                6                 2            OSVERSIONINFOEX.wProductType != VER_NT_WORKSTATION
		        'Windows 7                      6.1                6                 1            OSVERSIONINFOEX.wProductType == VER_NT_WORKSTATION
		        
		        If info.UInt8Value(154) <> 1 Then
		          m_IsServer = True
		        End If
		        
		      Else
		        Soft Declare Sub GetVersionExA Lib "Kernel32" ( ByRef info As m_WindowsOSVersionInfoEX )
		        
		        Dim info As m_WindowsOSVersionInfo
		        info.dwOSVersionInfoSize = info.StringValue.LenB
		        
		        GetVersionExA( info )
		        
		        m_Major = info.dwMajorVersion
		        m_Minor = info.dwMinorVersion
		        m_Patch = info.dwBuildNumber
		        
		      End If
		      
		  #EndIf
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return m_IsServer
			End Get
		#tag EndGetter
		IsServer As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private m_IsServer As Boolean
	#tag EndProperty


	#tag Structure, Name = m_OSVersionInfo, Flags = &h21, Attributes = \"StructureAlignment \x3D 1"
		major as integer
		  minor as integer
		bug as integer
	#tag EndStructure

	#tag Structure, Name = m_WindowsOSVersionInfo, Flags = &h21
		dwOSVersionInfoSize as Uint32
		  dwMajorVersion as Uint32
		  dwMinorVersion as Uint32
		  dwBuildNumber as Uint32
		  dwPlatformId  as Uint32
		  szCSDVersion as String*128
		
	#tag EndStructure

	#tag Structure, Name = m_WindowsOSVersionInfoEX, Flags = &h21
		dwOSVersionInfoSize as Uint32
		  dwMajorVersion as Uint32
		  dwMinorVersion as Uint32
		  dwBuildNumber  as Uint32
		  dwPlatformId  as Uint32
		  szCSDVersion as String*128
		  wServicePackMajor as Uint16
		  wServicePackMinor as Uint16
		  wSuiteMask as Uint16
		  wProductType as Uint8
		wReserved as Uint8
	#tag EndStructure


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
