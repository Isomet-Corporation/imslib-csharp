%{
#include <chrono>
#include <ratio>
%}

%include "stdint.i"

namespace std {

  template<int Num, int Denom = 1> class ratio {
  public:
    static constexpr int num;
    static constexpr int den;
  };

}

%template(UnitRatio) std::ratio<1, 1>;
%template(PostDelayRatio) std::ratio<1, 10000>;
%template(NanoRatio) std::ratio<1, 1000000000>;

namespace std {
namespace chrono {

  template <class Rep, class Period = ratio<1> >
  class duration
  {
  public:
    duration();
    duration(const duration&);
    explicit duration(const Rep& r);
    Rep count() const;
  };

}
}

/* ------------------------------------------------------------------
   Instantiate only the duration types used by the SDK
   ------------------------------------------------------------------ */

%template(PostDelay)        std::chrono::duration<uint16_t, std::ratio<1,10000>>;
%template(UnitIntDuration)  std::chrono::duration<int>;
%template(UnitFloatDuration) std::chrono::duration<double>;
%template(NanoSeconds)      std::chrono::duration<uint64_t, std::ratio<1,1000000000>>;


/* ------------------------------------------------------------------
   Map ALL durations to System.TimeSpan
   ------------------------------------------------------------------ */

%typemap(cstype) std::chrono::duration<uint16_t, std::ratio<1,10000>> "System.TimeSpan"
%typemap(cstype) std::chrono::duration<uint16_t, std::ratio<1,10000>>& "System.TimeSpan"
%typemap(cstype) const std::chrono::duration<uint16_t, std::ratio<1,10000>>& "System.TimeSpan"
%typemap(cstype, out="System.TimeSpan") std::chrono::duration<uint16_t, std::ratio<1,10000>>& "out System.TimeSpan"
%typemap(cstype, out="System.TimeSpan") std::chrono::duration<uint16_t, std::ratio<1,10000>> * "ref System.TimeSpan"

%typemap(cstype) std::chrono::duration<int> "System.TimeSpan"
%typemap(cstype) std::chrono::duration<int>& "System.TimeSpan"
%typemap(cstype) const std::chrono::duration<int>& "System.TimeSpan"
%typemap(cstype, out="System.TimeSpan") std::chrono::duration<int>& "out System.TimeSpan"
%typemap(cstype, out="System.TimeSpan") std::chrono::duration<int> * "ref System.TimeSpan"

%typemap(cstype) std::chrono::duration<double> "System.TimeSpan"
%typemap(cstype) std::chrono::duration<double>& "System.TimeSpan"
%typemap(cstype) const std::chrono::duration<double>& "System.TimeSpan"
%typemap(cstype, out="System.TimeSpan") std::chrono::duration<double>& "out System.TimeSpan"
%typemap(cstype, out="System.TimeSpan") std::chrono::duration<double> * "ref System.TimeSpan"

%typemap(cstype) std::chrono::duration<uint64_t, std::ratio<1,1000000000>> "System.TimeSpan"
%typemap(cstype) std::chrono::duration<uint64_t, std::ratio<1,1000000000>>& "System.TimeSpan"
%typemap(cstype) const std::chrono::duration<uint64_t, std::ratio<1,1000000000>>& "System.TimeSpan"
%typemap(cstype, out="System.TimeSpan") std::chrono::duration<uint64_t, std::ratio<1,1000000000>>& "out System.TimeSpan"
%typemap(cstype, out="System.TimeSpan") std::chrono::duration<uint64_t, std::ratio<1,1000000000>> * "ref System.TimeSpan"

/* ------------------------------------------------------------------
   INPUT: TimeSpan -> duration
   ------------------------------------------------------------------ */

   /* UnitFloatDuration <- std::chrono::duration<double> */
%typemap(csin, 
         pre="    UnitFloatDuration temp$csinput = new UnitFloatDuration($csinput.TotalSeconds);"
        ) const std::chrono::duration<double> &
         "$csclassname.getCPtr(temp$csinput)"

%typemap(csin, 
         pre="    UnitFloatDuration temp$csinput = new UnitFloatDuration($csinput.TotalSeconds);"
        ) std::chrono::duration<double>
         "$csclassname.getCPtr(temp$csinput)"

%typemap(csin, 
         pre="    UnitFloatDuration temp$csinput = new UnitFloatDuration();", 
         post="      $csinput = new System.TimeSpan(temp$csinput.count() * 1000)", 
         cshin="out $csinput"
        ) std::chrono::duration<double> &
         "$csclassname.getCPtr(temp$csinput)"

%typemap(csin,
         pre="    UnitFloatDuration temp$csinput = new UnitFloatDuration($csinput.TotalSeconds);",
         post="      $csinput = new System.TimeSpan(temp$csinput.count() * 1000)",
         cshin="ref $csinput"
        ) std::chrono::duration<double> *
         "$csclassname.getCPtr(temp$csinput)"

            /* UnitIntDuration <- std::chrono::duration<int> */
%typemap(csin, 
         pre="    UnitIntDuration temp$csinput = new UnitIntDuration((int)($csinput.TotalSeconds));"
        ) const std::chrono::duration< int > &
         "$csclassname.getCPtr(temp$csinput)"

%typemap(csin, 
         pre="    UnitIntDuration temp$csinput = new UnitIntDuration((int)($csinput.TotalSeconds));"
        ) std::chrono::duration< int >
         "$csclassname.getCPtr(temp$csinput)"

%typemap(csin, 
         pre="    UnitIntDuration temp$csinput = new UnitIntDuration();", 
         post="      $csinput = new System.TimeSpan(temp$csinput.count() * 1000)", 
         cshin="out $csinput"
        ) std::chrono::duration< int > &
         "$csclassname.getCPtr(temp$csinput)"

%typemap(csin,
         pre="    UnitIntDuration temp$csinput = new UnitIntDuration((int)($csinput.TotalSeconds));",
         post="      $csinput = new System.TimeSpan(temp$csinput.count() * 1000)",
         cshin="ref $csinput"
        ) std::chrono::duration< int > *
         "$csclassname.getCPtr(temp$csinput)"

         
            /* PostDelay <- std::chrono::duration<uint16_t, std::ratio<1, 10000>> */
%typemap(csin, 
         pre="    PostDelay temp$csinput = new PostDelay(System.Convert.ToUInt16($csinput.TotalMilliseconds * 10));"
        ) const std::chrono::duration< uint16_t, std::ratio<1, 10000> > &
         "$csclassname.getCPtr(temp$csinput)"

%typemap(csin, 
         pre="    PostDelay temp$csinput = new PostDelay(System.Convert.ToUInt16($csinput.TotalMilliseconds * 10));"
        ) std::chrono::duration< uint16_t, std::ratio<1, 10000> >
         "$csclassname.getCPtr(temp$csinput)"

%typemap(csin, 
         pre="    PostDelay temp$csinput = new PostDelay();", 
         post="      $csinput = new System.TimeSpan(temp$csinput.count() * 1000)", 
         cshin="out $csinput"
        ) std::chrono::duration< uint16_t, std::ratio<1, 10000> > &
         "$csclassname.getCPtr(temp$csinput)"

%typemap(csin,
         pre="    PostDelay temp$csinput = new PostDelay(System.Convert.ToUInt16($csinput.TotalMilliseconds * 10));",
         post="      $csinput = new System.TimeSpan(temp$csinput.count() * 1000)",
         cshin="ref $csinput"
        ) std::chrono::duration< uint16_t, std::ratio<1, 10000> > *
         "$csclassname.getCPtr(temp$csinput)"


            /* NanoSeconds <- std::chrono::duration< uint64_t, std::ratio<1, 1000000000> > */         
%typemap(csin, 
         pre="    NanoSeconds temp$csinput = new NanoSeconds(System.Convert.ToUInt64($csinput.TotalMilliseconds * 1000000.0));"
        ) const std::chrono::duration< uint64_t, std::ratio<1, 1000000000> > &
         "$csclassname.getCPtr(temp$csinput)"

%typemap(csin, 
         pre="    NanoSeconds temp$csinput = new NanoSeconds(System.Convert.ToUInt64($csinput.TotalMilliseconds * 1000000.0));"
        ) std::chrono::duration< uint64_t, std::ratio<1, 1000000000> >
         "$csclassname.getCPtr(temp$csinput)"

%typemap(csin, 
         pre="    NanoSeconds temp$csinput = new NanoSeconds();", 
         post="      $csinput = new System.TimeSpan(temp$csinput.count() * 1000)", 
         cshin="out $csinput"
        ) std::chrono::duration< uint64_t, std::ratio<1, 1000000000> > &
         "$csclassname.getCPtr(temp$csinput)"

%typemap(csin,
         pre="    NanoSeconds temp$csinput = new NanoSeconds(System.Convert.ToUInt64($csinput.TotalMilliseconds * 1000000.0));",
         post="      $csinput = new System.TimeSpan(temp$csinput.count() * 1000)",
         cshin="ref $csinput"
        ) std::chrono::duration< uint64_t, std::ratio<1, 1000000000> > *
         "$csclassname.getCPtr(temp$csinput)"


/* ------------------------------------------------------------------
   OUTPUT: duration -> TimeSpan
   ------------------------------------------------------------------ */

   // N/A

/* ------------------------------------------------------------------
   Property access (struct members etc.)
   ------------------------------------------------------------------ */

%typemap(csvarin, excode=SWIGEXCODE2) std::chrono::duration< int > * %{
    set {
      UnitIntDuration temp$csinput = new UnitIntDuration((int)($csinput.TotalSeconds));
      $imcall;$excode
    } %}

%typemap(csvarout, excode=SWIGEXCODE2) std::chrono::duration< int > * %{
    get {
      global::System.IntPtr cPtr = $imcall;
      UnitIntDuration tempTime = (cPtr == global::System.IntPtr.Zero) ? null : new UnitIntDuration(cPtr, $owner);$excode
      return new System.TimeSpan(tempTime.count() * 1000);
    } %}

%typemap(csvarin, excode=SWIGEXCODE2) std::chrono::duration< uint16_t, std::ratio<1, 10000> > * %{
    set {
      PostDelay temp$csinput = new PostDelay(System.Convert.ToUInt16($csinput.TotalMilliseconds * 10));
      $imcall;$excode
    } %}

%typemap(csvarout, excode=SWIGEXCODE2) std::chrono::duration< uint16_t, std::ratio<1, 10000> > * %{
    get {
      global::System.IntPtr cPtr = $imcall;
      PostDelay tempTime = (cPtr == global::System.IntPtr.Zero) ? null : new PostDelay(cPtr, $owner);$excode
      return new System.TimeSpan(tempTime.count() * 1000);
    } %}

%typemap(csvarin, excode=SWIGEXCODE2) const std::chrono::duration< double > & %{
    set {
      UnitFloatDuration temp$csinput = new UnitFloatDuration(System.Convert.ToInt64($csinput.TotalSeconds));
      $imcall;$excode
    } %}

%typemap(csvarout, excode=SWIGEXCODE2) const std::chrono::duration< double > & %{
    get {
      global::System.IntPtr cPtr = $imcall;
      UnitFloatDuration tempTime = (cPtr == global::System.IntPtr.Zero) ? null : new UnitFloatDuration(cPtr, $owner);$excode
      return new System.TimeSpan(System.Convert.ToInt64(tempTime.count() * 1000));
    } %}   

%typemap(csvarin, excode=SWIGEXCODE2) std::chrono::duration< double > %{
    set {
      UnitFloatDuration temp$csinput = new UnitFloatDuration(System.Convert.ToInt64($csinput.TotalSeconds));
      $imcall;$excode
    } %}

%typemap(csvarout, excode=SWIGEXCODE2) std::chrono::duration< double > %{
    get {
      global::System.IntPtr cPtr = $imcall;
      UnitFloatDuration tempTime = (cPtr == global::System.IntPtr.Zero) ? null : new UnitFloatDuration(cPtr, $owner);$excode
      return new System.TimeSpan(System.Convert.ToInt64(tempTime.count() * 1000));
    } %}    

%typemap(csvarin, excode=SWIGEXCODE2) std::chrono::duration< double >& %{
    set {
      UnitFloatDuration temp$csinput = new UnitFloatDuration(System.Convert.ToInt64($csinput.TotalSeconds));
      $imcall;$excode
    } %}

%typemap(csvarout, excode=SWIGEXCODE2) std::chrono::duration< double >& %{
    get {
      global::System.IntPtr cPtr = $imcall;
      UnitFloatDuration tempTime = (cPtr == global::System.IntPtr.Zero) ? null : new UnitFloatDuration(cPtr, $owner);$excode
      return new System.TimeSpan(System.Convert.ToInt64(tempTime.count() * 1000));
    } %}    

%typemap(csvarin, excode=SWIGEXCODE2) std::chrono::duration< uint64_t, std::ratio<1, 1000000000> > * %{
    set {
      NanoSeconds temp$csinput = new NanoSeconds(System.Convert.ToUInt64($csinput.TotalMilliseconds * 1000000.0));
      $imcall;$excode
    } %}

%typemap(csvarout, excode=SWIGEXCODE2) std::chrono::duration< uint64_t, std::ratio<1, 1000000000> > * %{
    get {
      global::System.IntPtr cPtr = $imcall;
      NanoSeconds tempTime = (cPtr == global::System.IntPtr.Zero) ? null : new NanoSeconds(cPtr, $owner);$excode
      return new System.TimeSpan(tempTime.count() * 1000);
    } %}
