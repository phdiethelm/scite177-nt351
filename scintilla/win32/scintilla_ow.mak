# Make file for Scintilla on Windows using OpenWatcom 1.9
# Copyright 1998-2003 by Neil Hodgson <neilh@scintilla.org>
# The License.txt file describes the conditions under which this software may be distributed.
# Usage:
#     wmake -f scintilla_ow.mak
# For debug versions define DEBUG on the command line, for Borland:
#     make DEBUG=1 -f scintilla_ow.mak
# The main makefile uses mingw32 gcc and may be more current than this file.

.EXTENSIONS:
.EXTENSIONS: .obj .cxx

DIR_BIN=..\bin

COMPONENT=$(DIR_BIN)\Scintilla.dll
LEXCOMPONENT=$(DIR_BIN)\SciLexer.dll

CC=wpp386
RC=wrc
LD=wlink

CXXFLAGS=-bm -zq -DWIN32 -zq -za0x -D_WIN32_WINNT=0x0351
CXXDEBUG=-DDEBUG
CXXNDEBUG=-Osrlran
NAME=-fo=
LDFLAGS=SYS nt_dll 
LDDEBUG=
LIBS=KERNEL32.lib USER32.lib GDI32.lib OLE32.LIB
NOLOGO=-zq

!IFDEF QUIET
CC=@$(CC)
CXXFLAGS=$(CXXFLAGS) $(NOLOGO)
LDFLAGS=$(LDFLAGS) $(NOLOGO)
!ENDIF

!IFDEF DEBUG
CXXFLAGS=$(CXXFLAGS) $(CXXDEBUG)
LDFLAGS=$(LDDEBUG) $(LDFLAGS)
!ELSE
CXXFLAGS=$(CXXFLAGS) $(CXXNDEBUG)
!ENDIF

INCLUDEDIRS=-I../include -I../src
CXXFLAGS=$(CXXFLAGS) $(INCLUDEDIRS)

ALL:	$(COMPONENT) $(LEXCOMPONENT) ScintillaWinS.obj WindowAccessor.obj

clean:
	-del /q *.obj *.pdb $(COMPONENT) $(LEXCOMPONENT) \
	*.res $(DIR_BIN)\*.map $(DIR_BIN)\*.exp $(DIR_BIN)\*.pdb $(DIR_BIN)\*.lib

SOBJS=	AutoComplete.obj &
	CallTip.obj &
	CellBuffer.obj &
	CharClassify.obj &
	ContractionState.obj &
	Decoration.obj &
	Document.obj &
	Editor.obj &
	Indicator.obj &
	KeyMap.obj &
	LineMarker.obj &
	PlatWin.obj &
	PositionCache.obj &
	PropSet.obj &
	RESearch.obj &
	RunStyles.obj &
	ScintillaBase.obj &
	ScintillaWin.obj &
	Style.obj &
	UniConversion.obj &
	ViewStyle.obj &
	XPM.obj

#++Autogenerated -- run src/LexGen.py to regenerate
#**LEXOBJS=\\\n\(\t\\*.obj \\\n\)
LEXOBJS=LexAbaqus.obj &
	LexAda.obj &
	LexAPDL.obj &
	LexAsm.obj &
	LexAsn1.obj &
	LexASY.obj &
	LexAU3.obj &
	LexAVE.obj &
	LexBaan.obj &
	LexBash.obj &
	LexBasic.obj &
	LexBullant.obj &
	LexCaml.obj &
	LexCLW.obj &
	LexCmake.obj &
	LexConf.obj &
	LexCPP.obj &
	LexCrontab.obj &
	LexCsound.obj &
	LexCSS.obj &
	LexD.obj &
	LexEiffel.obj &
	LexErlang.obj &
	LexEScript.obj &
	LexFlagship.obj &
	LexForth.obj &
	LexFortran.obj &
	LexGAP.obj &
	LexGui4Cli.obj &
	LexHaskell.obj &
	LexHTML.obj &
	LexInno.obj &
	LexKix.obj &
	LexLisp.obj &
	LexLout.obj &
	LexLua.obj &
	LexMagik.obj &
	LexMatlab.obj &
	LexMetapost.obj &
	LexMMIXAL.obj &
	LexMPT.obj &
	LexMSSQL.obj &
	LexMySQL.obj &
	LexNsis.obj &
	LexOpal.obj &
	LexOthers.obj &
	LexPascal.obj &
	LexPB.obj &
	LexPerl.obj &
	LexPLM.obj &
	LexPOV.obj &
	LexPowerShell.obj &
	LexProgress.obj &
	LexPS.obj &
	LexPython.obj &
	LexR.obj &
	LexRebol.obj &
	LexRuby.obj &
	LexScriptol.obj &
	LexSmalltalk.obj &
	LexSpecman.obj &
	LexSpice.obj &
	LexSQL.obj &
	LexTADS3.obj &
	LexTCL.obj &
	LexTeX.obj &
	LexVB.obj &
	LexVerilog.obj &
	LexVHDL.obj &
	LexYAML.obj

#--Autogenerated -- end of automatically generated section

LOBJS=	CallTip.obj &
	CellBuffer.obj &
	CharClassify.obj &
	ContractionState.obj &
	Decoration.obj &
	Document.obj &
	DocumentAccessor.obj &
	Editor.obj &
	ExternalLexer.obj &
	Indicator.obj &
	KeyMap.obj &
	KeyWords.obj &
	LineMarker.obj &
	PlatWin.obj &
	PositionCache.obj &
	PropSet.obj &
	RESearch.obj &
	RunStyles.obj &
	ScintillaBaseL.obj &
	ScintillaWinL.obj &
	Style.obj &
	StyleContext.obj &
	UniConversion.obj &
	ViewStyle.obj &
	XPM.obj &
	$(LEXOBJS)

ScintRes.res : ScintRes.rc
	$(RC) $*.rc -fo=$@ -r

$(COMPONENT): $(SOBJS)
	$(LD) $(LDFLAGS) NAME $@ F { $< } RES ScintRes.res
	
$(LEXCOMPONENT): $(LOBJS) AutoComplete.obj
	$(LD) $(LDFLAGS) NAME $@ F { $< }  RES ScintRes.res 

# Define how to build all the objects and what they depend on

# Most of the source is in ..\src with a couple in this directory
.cxx: ../src
.cxx.obj:
	$(CC) $(CXXFLAGS) -fo=$@ $< 

# Some source files are compiled into more than one object because of different conditional compilation
ScintillaBaseL.obj: ..\src\ScintillaBase.cxx
	$(CC) $(CXXFLAGS) -DSCI_LEXER $(NAME)$@ ..\src\ScintillaBase.cxx

ScintillaWinL.obj: ScintillaWin.cxx
	$(CC) $(CXXFLAGS) -DSCI_LEXER $(NAME)$@ ScintillaWin.cxx

ScintillaWinS.obj: ScintillaWin.cxx
	$(CC) $(CXXFLAGS) -DSTATIC_BUILD $(NAME)$@ ScintillaWin.cxx

# Dependencies
LEX_HEADERS=..\include\Platform.h ..\include\PropSet.h &
 ..\include\SString.h ..\include\Accessor.h ..\include\KeyWords.h &
 ..\include\Scintilla.h ..\include\SciLexer.h ..\src\StyleContext.h

AutoComplete.obj: ../src/AutoComplete.cxx 
CallTip.obj: ../src/CallTip.cxx 
CellBuffer.obj: ../src/CellBuffer.cxx 
CharClassify.obj: ../src/CharClassify.cxx
Decoration.obj: ../src/Decoration.cxx 
Document.obj: ../src/Document.cxx 
DocumentAccessor.obj: ../src/DocumentAccessor.cxx
Editor.obj: ../src/Editor.cxx 
ExternalLexer.obj: ../src/ExternalLexer.cxx 
Indicator.obj: ../src/Indicator.cxx 
KeyMap.obj: ../src/KeyMap.cxx 
KeyWords.obj: ../src/KeyWords.cxx 

#++Autogenerated -- run src/LexGen.py to regenerate
#**\n\(\\*.obj: ..\\src\\\*.cxx $(LEX_HEADERS)\n\n\)

LexAbaqus.obj: ..\src\LexAbaqus.cxx

LexAda.obj: ..\src\LexAda.cxx

LexAPDL.obj: ..\src\LexAPDL.cxx

LexAsm.obj: ..\src\LexAsm.cxx

LexAsn1.obj: ..\src\LexAsn1.cxx

LexASY.obj: ..\src\LexASY.cxx

LexAU3.obj: ..\src\LexAU3.cxx

LexAVE.obj: ..\src\LexAVE.cxx

LexBaan.obj: ..\src\LexBaan.cxx

LexBash.obj: ..\src\LexBash.cxx

LexBasic.obj: ..\src\LexBasic.cxx

LexBullant.obj: ..\src\LexBullant.cxx

LexCaml.obj: ..\src\LexCaml.cxx

LexCLW.obj: ..\src\LexCLW.cxx

LexCmake.obj: ..\src\LexCmake.cxx

LexConf.obj: ..\src\LexConf.cxx

LexCPP.obj: ..\src\LexCPP.cxx

LexCrontab.obj: ..\src\LexCrontab.cxx

LexCsound.obj: ..\src\LexCsound.cxx

LexCSS.obj: ..\src\LexCSS.cxx

LexD.obj: ..\src\LexD.cxx

LexEiffel.obj: ..\src\LexEiffel.cxx

LexErlang.obj: ..\src\LexErlang.cxx

LexEScript.obj: ..\src\LexEScript.cxx

LexFlagship.obj: ..\src\LexFlagship.cxx

LexForth.obj: ..\src\LexForth.cxx

LexFortran.obj: ..\src\LexFortran.cxx

LexGAP.obj: ..\src\LexGAP.cxx

LexGui4Cli.obj: ..\src\LexGui4Cli.cxx

LexHaskell.obj: ..\src\LexHaskell.cxx

LexHTML.obj: ..\src\LexHTML.cxx

LexInno.obj: ..\src\LexInno.cxx

LexKix.obj: ..\src\LexKix.cxx

LexLisp.obj: ..\src\LexLisp.cxx

LexLout.obj: ..\src\LexLout.cxx

LexLua.obj: ..\src\LexLua.cxx

LexMagik.obj: ..\src\LexMagik.cxx

LexMatlab.obj: ..\src\LexMatlab.cxx

LexMetapost.obj: ..\src\LexMetapost.cxx

LexMMIXAL.obj: ..\src\LexMMIXAL.cxx

LexMPT.obj: ..\src\LexMPT.cxx

LexMSSQL.obj: ..\src\LexMSSQL.cxx

LexMySQL.obj: ..\src\LexMySQL.cxx

LexNsis.obj: ..\src\LexNsis.cxx

LexOpal.obj: ..\src\LexOpal.cxx

LexOthers.obj: ..\src\LexOthers.cxx

LexPascal.obj: ..\src\LexPascal.cxx

LexPB.obj: ..\src\LexPB.cxx

LexPerl.obj: ..\src\LexPerl.cxx

LexPLM.obj: ..\src\LexPLM.cxx

LexPOV.obj: ..\src\LexPOV.cxx

LexPowerShell.obj: ..\src\LexPowerShell.cxx

LexProgress.obj: ..\src\LexProgress.cxx

LexPS.obj: ..\src\LexPS.cxx

LexPython.obj: ..\src\LexPython.cxx

LexR.obj: ..\src\LexR.cxx

LexRebol.obj: ..\src\LexRebol.cxx

LexRuby.obj: ..\src\LexRuby.cxx

LexScriptol.obj: ..\src\LexScriptol.cxx

LexSmalltalk.obj: ..\src\LexSmalltalk.cxx

LexSpecman.obj: ..\src\LexSpecman.cxx

LexSpice.obj: ..\src\LexSpice.cxx

LexSQL.obj: ..\src\LexSQL.cxx

LexTADS3.obj: ..\src\LexTADS3.cxx

LexTCL.obj: ..\src\LexTCL.cxx

LexTeX.obj: ..\src\LexTeX.cxx

LexVB.obj: ..\src\LexVB.cxx

LexVerilog.obj: ..\src\LexVerilog.cxx

LexVHDL.obj: ..\src\LexVHDL.cxx

LexYAML.obj: ..\src\LexYAML.cxx



