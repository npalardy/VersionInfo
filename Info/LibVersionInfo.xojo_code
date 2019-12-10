#tag Class
Protected Class LibVersionInfo
Inherits Info.VersionInfo
	#tag Method, Flags = &h0
		Sub Constructor(f as folderitem)
		  #If TargetMacOS
		    macOSInfo(f)
		  #ElseIf TargetWindows
		    windowsInfo(f)
		  #ElseIf TargetLinux
		    linuxInfo(f)
		  #ElseIf TargetIOS
		    iOSInfo(f)
		  #EndIf
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub iOSInfo(f as folderitem)
		  // wrapped just to make sure this code doesnt try to get compiled on other targets
		  #If TargetIOS
		    Break
		  #EndIf
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub linuxInfo(f as folderitem)
		  // wrapped just to make sure this code doesnt try to get compiled on other targets
		  #If TargetLinux
		    Break
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub macOSInfo(f as folderitem)
		  // wrapped just to make sure this code doesnt try to get compiled on other targets
		  #If TargetMacOS
		    
		    #If True
		      // attempt #1 which may / may not work well in all cases
		      
		      Dim s As New shell
		      s.execute "otool -L " + f.ShellPath
		      
		      If s.ErrorCode <> 0 Then
		        raise new UnsupportedOperationException
		      End If
		      
		      Dim result As String = s.result
		      result = ReplaceLineEndings(result, EndOfLine)
		      Dim lines() As String = result.Split(EndOfLine)
		      
		      For lineNum As Integer = 0 To lines.Ubound
		        If lines(lineNum).LTrim.Left(f.ShellPath.Len) = f.ShellPath Then
		          Dim thisLine As String = lines(lineNum).Trim
		          
		          If thisLine.Right(1) = ":" Then
		            Continue
		          End If
		          
		          // current version is listed after compat version
		          // ie/ /usr/lib/libssl.0.9.7.dylib (compatibility version 0.9.7, current version 0.9.7)
		          Dim currentVersionPortion As String = thisLine.NthField(",",2)
		          If currentVersionPortion.Trim = "" Then
		            Continue
		          End If
		          
		          // strip out everything that is not a digit or .
		          Dim chars() As String = currentVersionPortion.Split("")
		          For charPos As Integer = chars.Ubound DownTo 0
		            Select Case chars(charPos)
		            Case "0","1","2","3","4","5","6","7","8","9","."
		            Else
		              chars.Remove charPos
		            End Select
		          Next
		          
		          Dim cleanedVersionPortion As String = Join(chars,"")
		          Dim versionchunks() As String = Split(cleanedVersionPortion,".")
		          If versionchunks.ubound >= 0 Then
		            Me.m_Major = Val(versionchunks(0))
		          End If
		          If versionchunks.ubound >= 1 Then
		            Me.m_Minor = Val(versionchunks(1))
		          End If
		          If versionchunks.ubound >= 2 Then
		            Me.m_Patch = Val(versionchunks(2))
		          End If
		        End If
		      Next
		      
		    #ElseIf False
		      
		      // attempt #2
		      '#include <mach-o/dyld.h>
		      'int32_t library_version(Const char* libraryName)
		      '{
		      '   unsigned long i, j, n;
		      '   struct load_command *load_commands, *lc;
		      '   struct dylib_command *dl;
		      '   Const struct mach_header *mh;
		      '
		      '   n = _dyld_image_count;
		      '   For(i = 0; i < n; i++){
		      '      mh = _dyld_get_image_header(i);
		      '      If(mh->filetype != MH_DYLIB)
		      '         continue;
		      '      load_commands = (struct load_command *)
		      '      #If __LP64__
		      '         ((char *)mh + sizeof(struct mach_header_64));
		      '      #Else
		      '         ((char *)mh + sizeof(struct mach_header));
		      '      #EndIf
		      '      lc = load_commands;
		      '      For(j = 0; j < mh->ncmds; j++){
		      '         If(lc->cmd == LC_ID_DYLIB){
		      '            dl = (struct dylib_command *)lc;
		      '            If(strcmp(_dyld_get_image_name(i), libraryName) == 0)
		      '               Return(dl->dylib.current_version);
		      '         }
		      '         lc = (struct load_command *)((char *)lc + lc->cmdsize);
		      '      }
		      '   }
		      '   Return(-1);
		      '}
		    #ElseIf False
		      // attempt #3
		      // see "man 3 dyld"
		      //   int32_t NSVersionOfRunTimeLibrary(Const char* libraryName);
		      
		    #EndIf
		    
		  #EndIf
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub windowsInfo(f as folderitem)
		  // wrapped just to make sure this code doesnt try to get compiled on other targets
		  #If TargetWindows
		    
		    ' from https://docs.microsoft.com/en-ca/windows/win32/api/winver/nf-winver-getfileversioninfosizeexa
		    ' DWORD GetFileVersionInfoSizeA(LPCSTR  lptstrFilename, LPDWORD lpdwHandle);
		    ' from https://docs.microsoft.com/en-ca/windows/win32/api/winver/nf-winver-getfileversioninfoexa
		    ' BOOL GetFileVersionInfoA(LPCSTR lptstrFilename,DWORD  dwHandle,DWORD  dwLen,LPVOID lpData);
		    ' from https://docs.microsoft.com/en-ca/windows/win32/api/winver/nf-winver-verqueryvaluea
		    ' BOOL VerQueryValueA(LPCVOID pBlock,LPCSTR  lpSubBlock,LPVOID  *lplpBuffer,PUINT   puLen);
		    
		    ' from https://docs.microsoft.com/en-ca/windows/win32/api/winver/nf-winver-getfileversioninfosizeexw
		    ' DWORD GetFileVersionInfoSizeExW( DWORD   dwFlags, LPCWSTR lpwstrFilename, LPDWORD lpdwHandle );
		    ' from https://docs.microsoft.com/en-ca/windows/win32/api/winver/nf-winver-getfileversioninfoexw
		    ' BOOL GetFileVersionInfoExW( DWORD   dwFlags, LPCWSTR lpwstrFilename, DWORD   dwHandle, DWORD   dwLen, LPVOID  lpData );
		    ' from https://docs.microsoft.com/en-ca/windows/win32/api/winver/nf-winver-verqueryvaluew
		    ' BOOL VerQueryValueW( LPCVOID pBlock, LPCWSTR lpSubBlock, LPVOID  *lplpBuffer, PUINT   puLen );
		    
		    If System.IsFunctionAvailable( "GetFileVersionInfoSizeExW", "Version" ) Then
		      'Value                  Meaning
		      'FILE_VER_GET_LOCALISED Loads the entire version resource (both strings And binary version information) from the corresponding MUI file, If available.
		      '0x01
		      '
		      'FILE_VER_GET_NEUTRAL   Loads the version resource strings from the corresponding MUI file, If available, And loads the binary version information 
		      '0x002                  (VS_FIXEDFILEINFO) from the corresponding language-neutral file, If available.
		      
		      Dim dwFlags As UInt32 = &h2
		      
		      Soft Declare Function GetFileVersionInfoSizeExW Lib "Version" ( dwFlags As UInt32, lpwstrFilename As WString, ByRef lpdwHandle As UInt32 ) As UInt32
		      Soft Declare Function GetFileVersionInfoExW Lib "Version" ( dwFlags As UInt32, lpwstrFilename As WString, dwHandle As UInt32, dwLen As UInt32, lpData As Ptr) As Integer
		      Soft Declare Function VerQueryValueW Lib "Version" ( pBlock As Ptr, lpSubBlock As WString, ByRef lplpBuffer As Ptr, ByRef puLen As UInt32) As Integer
		      
		      Dim unused As UInt32
		      Dim size As UInt32 = GetFileVersionInfoSizeExW( dwFlags, f.NativePath, unused )
		      
		      If size = 0 Then
		        Return
		      End If
		      
		      Dim mb As New MemoryBlock(size)
		      mb.LittleEndian = False
		      
		      Dim retValue As Integer = GetFileVersionInfoExW ( dwFlags, f.NativePath, unused, size, mb) 
		      If retValue = 0 Then
		        Break
		        Return
		      End If
		      
		      'struct LANGANDCODEPAGE {
		      'WORD wLanguage; // Uint16
		      'WORD wCodePage; // Uint16
		      '} *lpTranslate;
		      '
		      // Read the list of languages and code pages.
		      '
		      Dim lplpBuffer As Ptr
		      Dim puLen As UInt32
		      retValue = VerQueryValueW(mb, "\", lplpBuffer, puLen) // "\VarFileInfo\Translation", lplpBuffer, puLen)
		      
		      If retValue = 0 Then
		        Break
		        Return
		      End If
		      
		      Dim dwSignature As UInt32
		      Dim dwStrucVersion As UInt32
		      Dim dwFileVersionMS As UInt32
		      Dim dwFileVersionLS As UInt32
		      Dim dwProductVersionMS As UInt32
		      Dim dwProductVersionLS As UInt32
		      Dim dwFileFlagsMask As UInt32
		      Dim dwFileFlags As UInt32
		      Dim dwFileOS As UInt32
		      Dim dwFileType As UInt32
		      Dim dwFileSubtype As UInt32
		      Dim dwFileDateMS As UInt32
		      Dim dwFileDateLS as Uint32
		      
		      dwFileVersionMS = lplpBuffer.VS_FIXEDFILEINFO.dwFileVersionMS
		      dwFileVersionLS = lplpBuffer.VS_FIXEDFILEINFO.dwFileVersionLS
		      dwFileType = lplpBuffer.VS_FIXEDFILEINFO.dwFileType
		      
		      Self.m_Major = Bitwise.ShiftRight(dwFileVersionMS, 16) And &hFFFF
		      Self.m_Minor = dwFileVersionMS And &hFFFF
		      Self.m_Patch = Bitwise.ShiftRight(dwFileVersionLS, 16) And &hFFFF
		      
		    Elseif System.IsFunctionAvailable( "GetFileVersionInfoSizeExA", "Kernel32" ) Then
		      Soft Declare Function GetFileVersionInfoSizeExA Lib "Kernel32" ( lptstrFilename As CString, ByRef lpdwHandle As UInt32) As UInt32
		      Soft Declare Function GetFileVersionInfoExA Lib "Kernel32" ( lptstrFilename As CString, dwHandle As UInt32, dwLen As UInt32, lpData As Ptr) As Integer
		      
		      Dim dwHandle As UInt32
		      Dim result As Integer = GetFileVersionInfoSizeExA( f.NativePath, dwHandle)
		      
		      Break
		      
		      'Soft Declare Function GetFileVersionInfoExA Lib "Kernel32" ( lptstrFilename As CString, dwHandle As UInt32, dwLen As UInt32, lpData As Ptr) As Integer
		    End If
		    
		  #EndIf
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return m_bug
			  
			End Get
		#tag EndGetter
		Bug As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private m_Bug As Integer
	#tag EndProperty


	#tag Structure, Name = VS_FIXEDFILEINFO, Flags = &h0
		dwSignature as Uint32
		  dwStrucVersion as Uint32
		  dwFileVersionMS as Uint32
		  dwFileVersionLS as Uint32
		  dwProductVersionMS as Uint32
		  dwProductVersionLS  as Uint32
		  dwFileFlagsMask as Uint32
		  dwFileMask  as Uint32
		  dwFileOS as Uint32
		  dwFileType as Uint32
		  dwFileSubType as Uint32
		  dwFileDateMS as Uint32
		dwFileDateLS  as Uint32
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
