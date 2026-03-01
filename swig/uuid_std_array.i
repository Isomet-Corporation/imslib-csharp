//
// std::array
//

// ------------------------------------------------------------------------
// std::array
// 
// The aim of all that follows would be to integrate std::array with 
// as much as possible, namely, to allow the user to pass and 
// be returned tuples or lists.
// const declarations are used to guess the intent of the function being
// exported; therefore, the following rationale is applied:
// 
//   -- f(std::array<T, N>), f(const std::array<T, N>&):
//      the parameter being read-only, either a sequence or a
//      previously wrapped std::array<T, N> can be passed.
//   -- f(std::array<T, N>&), f(std::array<T, N>*):
//      the parameter may be modified; therefore, only a wrapped std::array
//      can be passed.
//   -- std::array<T, N> f(), const std::array<T, N>& f():
//      the array is returned by copy; therefore, a sequence of T:s 
//      is returned which is most easily used in other functions
//   -- std::array<T, N>& f(), std::array<T, N>* f():
//      the array is returned by reference; therefore, a wrapped std::array
//      is returned
//   -- const std::array<T, N>* f(), f(const std::array<T, N>*):
//      for consistency, they expect and return a plain array pointer.
// ------------------------------------------------------------------------

// exported classes
namespace std {

  //  %apply int { array::size_type };
  %rename(get) array::at;
  template<class _Tp, size_t _Nm >
  class array {
  public:
#ifdef %swig_array_methods
    // Add swig/language extra methods
    %swig_array_methods(std::array< _Tp, _Nm >);
#endif

  array();
  array(const array&);

  bool empty() const;
  unsigned int size() const;
  void swap(array& v);

  #ifdef SWIG_EXPORT_ITERATOR_METHODS
  class iterator;
  class reverse_iterator;
  class const_iterator;
  class const_reverse_iterator;

  iterator begin();
  iterator end();
  reverse_iterator rbegin();
  reverse_iterator rend();
  #endif

  const _Tp& at(unsigned int n) const;
  %extend {
    void set(unsigned int n, _Tp val) {
      $self->at(n) = val;
    }
  }
  const _Tp& front() const;
  const _Tp& back() const;
  void fill(const _Tp& u);
  };
}

%template(UUID) std::array<uint8_t, 16>;
%template(VelGain) std::array<int16_t, 2>;

%typemap(cstype) const std::array<uint8_t, 16> & "System.Guid"
%typemap(csin, 
         pre="    global::iMS.UUID temp$csinput = new global::iMS.UUID();
     var arr = $csinput.ToByteArray();
     for (uint i=0; i<16; i++) temp$csinput.set(i, arr[i]);"
        ) const std::array<uint8_t, 16> &
         "global::iMS.UUID.getCPtr(temp$csinput)"
%apply const std::array<uint8_t, 16> & { std::array<uint8_t, 16> };

%typemap(cstype, out="System.Guid") std::array<uint8_t, 16> & "out System.Guid"
%typemap(csin, 
         pre="    global::iMS.UUID temp$csinput = new global::iMS.UUID();", 
         post="    var arr = new byte[16];
      for (uint i=0; i<16; i++) arr[i] = temp$csinput.get(i);
      $csinput = new System.Guid(arr);", 
         cshin="out $csinput"
        ) std::array<uint8_t, 16> &
         "global::iMS.UUID.getCPtr(temp$csinput)"

%typemap(cstype, out="System.Guid") std::array<uint8_t, 16> * "ref System.Guid"
%typemap(csin,
         pre="    global::iMS.UUID temp$csinput = new global::iMS.UUID();
      var arr = $csinput.ToByteArray();
      for (uint i=0; i<16; i++) temp$csinput.set(i, arr[i]);",
	 post="      for (uint i=0; i<16; i++) arr[i] = temp$csinput.get(i);
      $csinput = new System.Guid(arr);", 
         cshin="ref $csinput"
        ) std::array<uint8_t, 16> *
         "global::iMS.UUID.getCPtr(temp$csinput)"

%typemap(csvarin, excode=SWIGEXCODE2) std::array<uint8_t, 16> * %{
    /* csvarin typemap code */
    set {
      global::iMS.UUID temp$csinput = new global::iMS.UUID();
      var arr = $csinput.ToByteArray();
      for (uint i=0; i<16; i++) temp$csinput.set(i, arr[i]);
      $imcall;$excode
    } %}

%typemap(csvarout, excode=SWIGEXCODE2) std::array<uint8_t, 16> * %{
    /* csvarout typemap code */
    get {
      global::System.IntPtr cPtr = $imcall;
      global::iMS.UUID tempUuid = new global::iMS.UUID(cPtr, $owner);$excode
      var arr = new byte[16];
      for (uint i=0; i<16; i++) arr[i] = tempUuid.get(i);
      return (cPtr == global::System.IntPtr.Zero) ? System.Guid.Empty : new System.Guid(arr);
    } %}

