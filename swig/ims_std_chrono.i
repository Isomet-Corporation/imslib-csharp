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

    //    %rename(__set__) duration::operator=;
    template <class Rep, class Period = ratio<1> > class duration  
    {
      public:
	constexpr duration() = default;
	duration( const duration& ) = default;
	constexpr explicit duration<Rep>( const Rep& r );
      //constexpr duration<Rep, Period>( const duration<Rep,Period>& d );
      //  	duration& operator=( const duration &other ) = default;
	constexpr Rep count() const;
	};

  }
}

%typemap(cstype) const std::chrono::duration< uint16_t, std::ratio<1, 10000> > & "System.TimeSpan"
%typemap(csin, 
         pre="    PostDelay temp$csinput = new PostDelay(System.Convert.ToUInt16($csinput.TotalMilliseconds * 10));"
        ) const std::chrono::duration< uint16_t, std::ratio<1, 10000> > &
         "$csclassname.getCPtr(temp$csinput)"

%typemap(cstype, out="System.TimeSpan") std::chrono::duration< uint16_t, std::ratio<1, 10000> > & "out System.TimeSpan"
%typemap(csin, 
         pre="    PostDelay temp$csinput = new PostDelay();", 
         post="      $csinput = new System.TimeSpan(temp$csinput.count() * 1000)", 
         cshin="out $csinput"
        ) std::chrono::duration< uint16_t, std::ratio<1, 10000> > &
         "$csclassname.getCPtr(temp$csinput)"

%typemap(cstype, out="System.TimeSpan") std::chrono::duration< uint16_t, std::ratio<1, 10000> > * "ref System.TimeSpan"
%typemap(csin,
         pre="    PostDelay temp$csinput = new PostDelay(System.Convert.ToUInt16($csinput.TotalMilliseconds * 10));",
         post="      $csinput = new System.TimeSpan(temp$csinput.count() * 1000)",
         cshin="ref $csinput"
        ) std::chrono::duration< uint16_t, std::ratio<1, 10000> > *
         "$csclassname.getCPtr(temp$csinput)"

%typemap(csvarin, excode=SWIGEXCODE2) std::chrono::duration< uint16_t, std::ratio<1, 10000> > * %{
    /* csvarin typemap code */
    set {
      PostDelay temp$csinput = new PostDelay(System.Convert.ToUInt16($csinput.TotalMilliseconds * 10));
      $imcall;$excode
    } %}

%typemap(csvarout, excode=SWIGEXCODE2) std::chrono::duration< uint16_t, std::ratio<1, 10000> > * %{
    /* csvarout typemap code */
    get {
      global::System.IntPtr cPtr = $imcall;
      PostDelay tempTime = (cPtr == global::System.IntPtr.Zero) ? null : new PostDelay(cPtr, $owner);$excode
      return new System.TimeSpan(tempTime.count() * 1000);
    } %}

//    template<> class std::chrono::duration<int, std::ratio<1> >;

%typemap(cstype) const std::chrono::duration< int, std::ratio<1> > & "System.TimeSpan"
%typemap(csin, 
         pre="    UnitIntDuration temp$csinput = new UnitIntDuration((int)($csinput.TotalSeconds));"
        ) const std::chrono::duration< int, std::ratio<1> > &
         "$csclassname.getCPtr(temp$csinput)"

%typemap(cstype, out="System.TimeSpan") std::chrono::duration< int, std::ratio<1> > & "out System.TimeSpan"
%typemap(csin, 
         pre="    UnitIntDuration temp$csinput = new UnitIntDuration();", 
         post="      $csinput = new System.TimeSpan(temp$csinput.count() * 1000)", 
         cshin="out $csinput"
        ) std::chrono::duration< int, std::ratio<1> > &
         "$csclassname.getCPtr(temp$csinput)"

%typemap(cstype, out="System.TimeSpan") std::chrono::duration< int, std::ratio<1> > * "ref System.TimeSpan"
%typemap(csin,
         pre="    UnitIntDuration temp$csinput = new UnitIntDuration((int)($csinput.TotalSeconds));",
         post="      $csinput = new System.TimeSpan(temp$csinput.count() * 1000)",
         cshin="ref $csinput"
        ) std::chrono::duration< int, std::ratio<1> > *
         "$csclassname.getCPtr(temp$csinput)"

%typemap(csvarin, excode=SWIGEXCODE2) std::chrono::duration< int, std::ratio<1> > * %{
    /* csvarin typemap code */
    set {
      UnitIntDuration temp$csinput = new UnitIntDuration((int)($csinput.TotalSeconds));
      $imcall;$excode
    } %}

%typemap(csvarout, excode=SWIGEXCODE2) std::chrono::duration< int, std::ratio<1> > * %{
    /* csvarout typemap code */
    get {
      global::System.IntPtr cPtr = $imcall;
      UnitIntDuration tempTime = (cPtr == global::System.IntPtr.Zero) ? null : new UnitIntDuration(cPtr, $owner);$excode
      return new System.TimeSpan(tempTime.count() * 1000);
    } %}

//    template<> class std::chrono::duration<double, std::ratio<1> >;

%typemap(cstype) const std::chrono::duration< double, std::ratio<1> > & "System.TimeSpan"
%typemap(csin, 
         pre="    UnitFloatDuration temp$csinput = new UnitFloatDuration($csinput.TotalSeconds);"
        ) const std::chrono::duration< double, std::ratio<1> > &
         "$csclassname.getCPtr(temp$csinput)"

%typemap(cstype, out="System.TimeSpan") std::chrono::duration< double, std::ratio<1> > & "out System.TimeSpan"
%typemap(csin, 
         pre="    UnitFloatDuration temp$csinput = new UnitFloatDuration();", 
         post="      $csinput = new System.TimeSpan(temp$csinput.count() * 1000)", 
         cshin="out $csinput"
        ) std::chrono::duration< double, std::ratio<1> > &
         "$csclassname.getCPtr(temp$csinput)"

%typemap(cstype, out="System.TimeSpan") std::chrono::duration< double, std::ratio<1> > * "ref System.TimeSpan"
%typemap(csin,
         pre="    UnitFloatDuration temp$csinput = new UnitFloatDuration($csinput.TotalSeconds);",
         post="      $csinput = new System.TimeSpan(temp$csinput.count() * 1000)",
         cshin="ref $csinput"
        ) std::chrono::duration< double, std::ratio<1> > *
         "$csclassname.getCPtr(temp$csinput)"

%typemap(csvarin, excode=SWIGEXCODE2) std::chrono::duration< double, std::ratio<1> > & %{
    /* csvarin typemap code */
    set {
      UnitFloatDuration temp$csinput = new UnitFloatDuration(System.Convert.ToInt64($csinput.TotalSeconds));
      $imcall;$excode
    } %}

%typemap(csvarout, excode=SWIGEXCODE2) std::chrono::duration< double, std::ratio<1> > & %{
    /* csvarout typemap code */
    get {
      global::System.IntPtr cPtr = $imcall;
      UnitFloatDuration tempTime = (cPtr == global::System.IntPtr.Zero) ? null : new UnitFloatDuration(cPtr, $owner);$excode
      return new System.TimeSpan(System.Convert.ToInt64(tempTime.count() * 1000));
    } %}


%typemap(cstype) const std::chrono::duration< uint64_t, std::ratio<1, 1000000000> > & "System.TimeSpan"
%typemap(csin, 
         pre="    NanoSeconds temp$csinput = new NanoSeconds(System.Convert.ToUInt64($csinput.TotalMilliseconds * 1000000.0));"
        ) const std::chrono::duration< uint64_t, std::ratio<1, 1000000000> > &
         "$csclassname.getCPtr(temp$csinput)"

%typemap(cstype, out="System.TimeSpan") std::chrono::duration< uint64_t, std::ratio<1, 1000000000> > & "out System.TimeSpan"
%typemap(csin, 
         pre="    NanoSeconds temp$csinput = new NanoSeconds();", 
         post="      $csinput = new System.TimeSpan(temp$csinput.count() * 1000)", 
         cshin="out $csinput"
        ) std::chrono::duration< uint64_t, std::ratio<1, 1000000000> > &
         "$csclassname.getCPtr(temp$csinput)"

%typemap(cstype, out="System.TimeSpan") std::chrono::duration< uint64_t, std::ratio<1, 1000000000> > * "ref System.TimeSpan"
%typemap(csin,
         pre="    NanoSeconds temp$csinput = new NanoSeconds(System.Convert.ToUInt64($csinput.TotalMilliseconds * 1000000.0));",
         post="      $csinput = new System.TimeSpan(temp$csinput.count() * 1000)",
         cshin="ref $csinput"
        ) std::chrono::duration< uint64_t, std::ratio<1, 1000000000> > *
         "$csclassname.getCPtr(temp$csinput)"

%typemap(csvarin, excode=SWIGEXCODE2) std::chrono::duration< uint64_t, std::ratio<1, 1000000000> > * %{
    /* csvarin typemap code */
    set {
      NanoSeconds temp$csinput = new NanoSeconds(System.Convert.ToUInt64($csinput.TotalMilliseconds * 1000000.0));
      $imcall;$excode
    } %}

%typemap(csvarout, excode=SWIGEXCODE2) std::chrono::duration< uint64_t, std::ratio<1, 1000000000> > * %{
    /* csvarout typemap code */
    get {
      global::System.IntPtr cPtr = $imcall;
      NanoSeconds tempTime = (cPtr == global::System.IntPtr.Zero) ? null : new NanoSeconds(cPtr, $owner);$excode
      return new System.TimeSpan(tempTime.count() * 1000);
    } %}

%template(PostDelay)  std::chrono::duration<uint16_t, std::ratio<1, 10000> >;
%template(UnitIntDuration)  std::chrono::duration<int>;
%template(UnitFloatDuration)  std::chrono::duration<double>;       
%template(NanoSeconds)  std::chrono::duration<uint64_t, std::ratio<1, 1000000000>>;
