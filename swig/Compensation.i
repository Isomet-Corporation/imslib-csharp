namespace iMS
{
  enum class CompensationEvents {
    RX_DDS_POWER,
    DOWNLOAD_FINISHED,
    DOWNLOAD_ERROR,
    VERIFY_SUCCESS,
    VERIFY_FAIL
  };
  
  enum class CompensationFeature {
    AMPLITUDE,
    PHASE,
    SYNC_DIG,
    SYNC_ANLG
  };

  enum class CompensationModifier {
    REPLACE,
    MULTIPLY
  };
}

%attribute_custom(iMS::CompensationPoint, iMS::Percent&, Amplitude, GetAmplitude, SetAmplitude, self_->Amplitude(), self_->Amplitude(val_));
%typemap(csvarin, excode=SWIGEXCODE2) iMS::Percent& Amplitude %{
  set {
    $imcall;$excode 
	      //   this.NotifyPropertyChanged("Amplitude");
  }
%}
%attribute_custom(iMS::CompensationPoint, iMS::Degrees&, Phase, GetPhase, SetPhase, self_->Phase(), self_->Phase(val_));
%typemap(csvarin, excode=SWIGEXCODE2) iMS::Degrees& Phase %{
  set {
    $imcall;$excode 
	      //   this.NotifyPropertyChanged("Phase");
  }
%}
%attribute_custom(iMS::CompensationPoint, uint32_t, SyncDig, GetSyncDig, SetSyncDig, self_->SyncDig(), self_->SyncDig(val_));
%typemap(csvarin, excode=SWIGEXCODE2) uint32_t SyncDig %{
  set {
    $imcall;$excode 
	      //  this.NotifyPropertyChanged("SyncDig");
  }
%}
%attribute_custom(iMS::CompensationPoint, double, SyncAnlg, GetSyncAnlg, SetSyncAnlg, self_->SyncAnlg(), self_->SyncAnlg(val_));
%typemap(csvarin, excode=SWIGEXCODE2) double SyncAnlg %{
  set {
    $imcall;$excode 
	      //   this.NotifyPropertyChanged("SyncAnlg");
  }
%}

namespace iMS
{
  %typemap(csinterfaces) CompensationPoint "System.IDisposable, System.ComponentModel.INotifyPropertyChanged";
  class CompensationPoint
  {
    %typemap(cscode) CompensationPoint %{
      public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;

      public void NotifyPropertyChanged(string propName)
      {
	if(this.PropertyChanged != null)
	  this.PropertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propName));
      }
    %}
  public:
    CompensationPoint(Percent ampl = Percent(0.0), Degrees phase = Degrees(0.0), unsigned int sync_dig = 0, double sync_anlg = 0.0);
    CompensationPoint(Degrees phase, unsigned int sync_dig = 0, double sync_anlg = 0.0);
    CompensationPoint(unsigned int sync_dig, double sync_anlg = 0.0);
    CompensationPoint(double sync_anlg);
  };
  
}

%attribute_custom(iMS::CompensationPointSpecification, iMS::MHz&, Freq, GetFreq, SetFreq, self_->Freq(), self_->Freq(val_));
%typemap(csvarin, excode=SWIGEXCODE2) iMS::MHz& Freq %{
  set {
    $imcall;$excode 
    this.NotifyPropertyChanged("Freq");
  }
%}
%attribute_custom(iMS::CompensationPointSpecification, iMS::CompensationPoint&, Spec, GetSpec, SetSpec, self_->Spec(), self_->Spec(val_));
%typemap(csvarin, excode=SWIGEXCODE2) iMS::CompensationPoint& Spec %{
  set {
    $imcall;$excode 
    this.NotifyPropertyChanged("Spec");
  }
%}

namespace iMS
{
  %typemap(csinterfaces) CompensationPointSpecification "System.IDisposable, System.ComponentModel.INotifyPropertyChanged";
  class CompensationPointSpecification
  {
    %typemap(cscode) CompensationPointSpecification %{
      public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;

      public void NotifyPropertyChanged(string propName)
      {
	if(this.PropertyChanged != null)
	  this.PropertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propName));
      }
    %}
  public:
    CompensationPointSpecification(CompensationPoint pt = CompensationPoint(), MHz f = 50.0);
    CompensationPointSpecification(const CompensationPointSpecification &);
  };
}

%attribute_custom(iMS::CompensationFunction, iMS::CompensationFunction::InterpolationStyle, AmplitudeInterpolationStyle,
		  GetStyle, SetStyle, self_->GetStyle(iMS::CompensationFeature::AMPLITUDE), self_->SetStyle(iMS::CompensationFeature::AMPLITUDE, val_));
%attribute_custom(iMS::CompensationFunction, iMS::CompensationFunction::InterpolationStyle, PhaseInterpolationStyle,
		  GetStyle, SetStyle, self_->GetStyle(iMS::CompensationFeature::PHASE), self_->SetStyle(iMS::CompensationFeature::PHASE, val_));
%attribute_custom(iMS::CompensationFunction, iMS::CompensationFunction::InterpolationStyle, SyncAnlgInterpolationStyle,
		  GetStyle, SetStyle, self_->GetStyle(iMS::CompensationFeature::SYNC_ANLG), self_->SetStyle(iMS::CompensationFeature::SYNC_ANLG, val_));
%attribute_custom(iMS::CompensationFunction, iMS::CompensationFunction::InterpolationStyle, SyncDigInterpolationStyle,
		  GetStyle, SetStyle, self_->GetStyle(iMS::CompensationFeature::SYNC_DIG), self_->SetStyle(iMS::CompensationFeature::SYNC_DIG, val_));
%typemap(csvarin, excode=SWIGEXCODE2) iMS::CompensationFunction::InterpolationStyle AmplitudeInterpolationStyle %{
  set {
    $imcall;$excode 
	      this.NotifyPropertyChanged("AmplitudeInterpolationStyle");
  }
%}
%typemap(csvarin, excode=SWIGEXCODE2) iMS::CompensationFunction::InterpolationStyle PhaseInterpolationStyle %{
  set {
    $imcall;$excode 
	      this.NotifyPropertyChanged("PhaseInterpolationStyle");
  }
%}
%typemap(csvarin, excode=SWIGEXCODE2) iMS::CompensationFunction::InterpolationStyle SyncAnlgInterpolationStyle %{
  set {
    $imcall;$excode 
	      this.NotifyPropertyChanged("SyncAnlgInterpolationStyle");
  }
%}
%typemap(csvarin, excode=SWIGEXCODE2) iMS::CompensationFunction::InterpolationStyle SyncDigInterpolationStyle %{
  set {
    $imcall;$excode 
	      this.NotifyPropertyChanged("SyncDigInterpolationStyle");
  }
%}
namespace iMS {
  class CompensationFunction : public ListBase < CompensationPointSpecification >
  {
    %typemap(cscode) CompensationFunction %{
      public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;

      public void NotifyPropertyChanged(string propName)
      {
	if(this.PropertyChanged != null)
	  this.PropertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propName));
      }
    %}
  public:
    enum class InterpolationStyle {
      SPOT,
      STEP,
      LINEAR,
      LINEXTEND,
      BSPLINE
    };

    CompensationFunction();
    CompensationFunction(const CompensationFunction &);

    //    void SetStyle(const CompensationFeature feat, const InterpolationStyle style);
    //    InterpolationStyle GetStyle(const CompensationFeature feat) const;

  };
}

%attributeval(iMS::CompensationTable, iMS::MHz, Upper, UpperFrequency)
%attributeval(iMS::CompensationTable, iMS::MHz, Lower, LowerFrequency)
namespace iMS {
  
  class CompensationTable : public DequeBase < CompensationPoint >
  {
  public:
    CompensationTable();
    CompensationTable(std::shared_ptr<IMSSystem> iMS);
    CompensationTable(int LUTDepth, const MHz& lower_freq, const MHz& upper_freq);
    CompensationTable(std::shared_ptr<IMSSystem> iMS, const CompensationPoint& pt);
    CompensationTable(int LUTDepth, const MHz& lower_freq, const MHz& upper_freq, const CompensationPoint& pt);
    CompensationTable(std::shared_ptr<IMSSystem> iMS, const std::string& fileName, const RFChannel& chan = RFChannel::all);
    CompensationTable(int LUTDepth, const MHz& lower_freq, const MHz& upper_freq, const std::string& fileNamee, const RFChannel& chan = RFChannel::all);
    CompensationTable(std::shared_ptr<IMSSystem> iMS, const int entry);
    CompensationTable(std::shared_ptr<IMSSystem> iMS, const CompensationTable& tbl);
    CompensationTable(int LUTDepth, const MHz& lower_freq, const MHz& upper_freq, const CompensationTable& tbl);

    CompensationTable(const CompensationTable &);
    %rename(Assign) operator=;
    CompensationTable &operator =(const CompensationTable &);

    bool ApplyFunction(const CompensationFunction& func, const CompensationFeature feat, CompensationModifier modifier = CompensationModifier::REPLACE);
    bool ApplyFunction(const CompensationFunction& func, CompensationModifier modifier = CompensationModifier::REPLACE);

    const std::size_t Size() const;
    const MHz FrequencyAt(const unsigned int index) const;
    const MHz LowerFrequency() const;
    const MHz UpperFrequency() const;
    const bool Save(const std::string& fileName) const;
  };
  
}

namespace iMS {
  class CompensationTableExporter
  {
  public:
    CompensationTableExporter(std::shared_ptr<IMSSystem> ims);
    CompensationTableExporter(const int channels);
    CompensationTableExporter();
    CompensationTableExporter(const CompensationTable& tbl);
    
    void ProvideGlobalTable(const CompensationTable& tbl);
    void ProvideChannelTable(const RFChannel& chan, const CompensationTable& tbl);

    bool ExportGlobalLUT(const std::string& fileName);
    bool ExportChannelLUT(const std::string& fileName);
  };
}

%attribute(iMS::CompensationTableImporter, int, Size, Size);
%attributeval(iMS::CompensationTableImporter, iMS::MHz, LowerFrequency, LowerFrequency);
%attributeval(iMS::CompensationTableImporter, iMS::MHz, UpperFrequency, UpperFrequency);

namespace iMS {
  class CompensationTableImporter
  {
  public:
    CompensationTableImporter(const std::string& fileName);

    bool IsValid() const;
    bool IsGlobal() const;
    int Channels() const;

    int Size() const;
    MHz LowerFrequency() const;
    MHz UpperFrequency() const;

    CompensationTable RetrieveGlobalLUT();
    CompensationTable RetrieveChannelLUT(RFChannel& chan);
  };
}

namespace iMS {

  class CompensationTableDownload
  {
  public:
    CompensationTableDownload(std::shared_ptr<IMSSystem> ims, const CompensationTable& tbl);
    bool StartDownload();
    bool StartVerify();
    int GetVerifyError();
    void CompensationTableDownloadEventSubscribe(const int message, IEventHandler* handler);
    void CompensationTableDownloadEventUnsubscribe(const int message, const IEventHandler* handler);
    const FileSystemIndex Store(FileDefault def, const std::string& FileName) const;	
  };

}
