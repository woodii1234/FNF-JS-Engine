package backend;

import Note.PreloadedChartNote;

class NoteSignalStuff
{
    inline static public var UPDATE_GAMEPLAY:SignalType.SignalType1<(Float)->(Void), (Float)> = "gameplay_update";
    public static inline var NOTE_UPDATE:SignalType.SignalType1<(Note)->(Void), (Note)> = "note_update";
    public static inline var NOTE_SETUP:SignalType.SignalType1<(PreloadedChartNote)->(Note), (PreloadedChartNote)> = "note_setup";

    public static inline var NOTE_HIT_BF:SignalType.SignalType2<(Note, PreloadedChartNote)->(Void), (Note), (PreloadedChartNote)> = "note_hit_bf";
    public static inline var NOTE_HIT_OPP:SignalType.SignalType2<(Note, PreloadedChartNote)->(Void), (Note), (PreloadedChartNote)> = "note_hit_opp";

    public static inline var NOTE_HIT_BF_EDITOR:SignalType.SignalType1<(Note)->(Void), (Note)> = "note_hit_bf_editor";
}