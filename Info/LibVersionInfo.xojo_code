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
		    Break
		  #EndIf
		End Sub
	#tag EndMethod


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
