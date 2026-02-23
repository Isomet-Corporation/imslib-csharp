%include <std_shared_ptr.i>
%include <std_string.i>

#include "IConnectionSettings.h"
#include "CS_ETH.h"
#include "CS_RS422.h"

namespace iMS {

  struct FWVersion
  {
    %immutable;
    const int major{ -1 };
    const int minor{ 0 };
    const int revision{ 0 };
    %mutable;
  };
}

namespace iMS {

  class IMSOption
  {
  public:
	const std::string& Name() const;
  };
}

%shared_ptr(iMS::IMSOption)

    // Define a dummy mirror struct to replace the nested struct
    %immutable;
    %inline %{
    namespace iMS {
    struct IMSControllerCapabilities {
        int nSynthInterfaces;
        bool FastImageTransfer;
        int MaxImageSize;
        bool SimultaneousPlayback;
        double MaxImageRate;
        bool RemoteUpgrade;
    };
    }
    %}
    %mutable;        

    %typemap(cscode) IMSController::Capabilities %{
        public IMSControllerCapabilities Capabilities
        {
            get {
                return new IMSControllerCapabilities {
                    nSynthInterfaces = (int)this.GetCap().nSynthInterfaces,
                    FastImageTransfer = this.GetCap().FastImageTransfer,
                    MaxImageSize = (int)this.GetCap().MaxImageSize,
                    SimultaneousPlayback = this.GetCap().SimultaneousPlayback,
                    MaxImageRate = this.GetCap().MaxImageRate,
                    RemoteUpgrade = this.GetCap().RemoteUpgrade
                };
            }
        }
    %}    

namespace iMS {

  class IMSController
  {
  public:
    const IMSController::Capabilities GetCap() const;
    const std::string& Description() const;
    const std::string& Model() const;
    const FWVersion& GetVersion() const;
    const ImageTable& ImgTable() const;  
    const bool IsValid() const;
    const ListBase<std::string>& Interfaces() const;
  };

}

    %immutable;
    %inline %{
    namespace iMS {
    struct IMSSynthesiserCapabilities {
      double lowerFrequency;
      double upperFrequency;
      int freqBits;
      int amplBits;
      int phaseBits;
      int LUTDepth;
      int LUTAmplBits;
      int LUTPhaseBits;
      int LUTSyncABits;
      int LUTSyncDBits;
      double sysClock;
      double syncClock;
      int channels;
      bool RemoteUpgrade;
      bool ChannelComp;
    };
    }
    %}
    %mutable;

    %typemap(cscode) IMSSynthesiser::Capabilities %{
        public IMSSynthesiserCapabilities Capabilities
        {
            get {
                return new IMSSynthesiserCapabilities {
                    lowerFrequency = this.GetCap().lowerFrequency,
                    upperFrequency = this.GetCap().upperFrequency,
                    freqBits = this.GetCap().freqBits,
                    amplBits = this.GetCap().amplBits,
                    phaseBits = this.GetCap().phaseBits,
                    LUTDepth = this.GetCap().LUTDepth,
                    LUTAmplBits = this.GetCap().LUTAmplBits,
                    LUTPhaseBits = this.GetCap().LUTPhaseBits,
                    LUTSyncABits = this.GetCap().LUTSyncABits,
                    LUTSyncDBits = this.GetCap().LUTSyncDBits,
                    sysClock = this.GetCap().sysClock,
                    sysClock = this.GetCap().,
                    channels = this.GetCap().channels,
                    RemoteUpgrade = this.GetCap().RemoteUpgrade,
                    ChannelComp = this.GetCap().ChannelComp
                };
            }
        }
    %}

namespace iMS {

  class IMSSynthesiser
  {
  public:
    std::shared_ptr<const IMSOption> AddOn() const;
    const IMSSynthesiser::Capabilities GetCap() const;
    const std::string& Description() const;
    const std::string& Model() const;
    const FWVersion& GetVersion() const;
    const bool IsValid() const;
    const FileSystemTable& FST() const;
  };
}

%ignore iMS::IConnectionSettings::IConnectionSettings;
%ignore iMS::IConnectionSettings::~IConnectionSettings;

namespace iMS {

  class IConnectionSettings
  {
  public:
    virtual IConnectionSettings() = 0;
  	virtual ~IConnectionSettings() {}
  };
}

%attribute(iMS::CS_ETH, bool, dhcp, UseDHCP, UseDHCP);
%attributestring(iMS::CS_ETH, std::string, addr, Address, Address);
%attributestring(iMS::CS_ETH, std::string, mask, Netmask, Netmask);
%attributestring(iMS::CS_ETH, std::string, gw, Gateway, Gateway);

namespace iMS {
  class CS_ETH : public IConnectionSettings
  {
  public:
    
    CS_ETH(bool use_dhcp = false,
	   std::string addr = std::string("192.168.1.10"),
	   std::string netmask = std::string("255.255.255.0"),
	   std::string gw = std::string("192.168.1.1"));
    ~CS_ETH();
    
       void UseDHCP(bool dhcp);
       bool UseDHCP() const; 
       void Address(const std::string& addr);
       std::string Address() const;
       void Netmask(const std::string& mask);
       std::string Netmask() const;
    
       void Gateway(const std::string& gw);
       std::string Gateway() const;
       const std::string& Ident() const;
  };
}

%attribute(iMS::CS_RS422, unsigned int, baud, BaudRate, BaudRate);
%attribute(iMS::CS_RS422, iMS::CS_RS422::ParitySetting, parity, Parity, Parity);
%attribute(iMS::CS_RS422, iMS::CS_RS422::DataBitsSetting, databits, DataBits, DataBits);
%attribute(iMS::CS_RS422, iMS::CS_RS422::StopBitsSetting, stopbits, StopBits, StopBits);

namespace iMS {

  class CS_RS422 : public IConnectionSettings
  {
  public:
        CS_RS422();
        CS_RS422(unsigned int baud_rate);
        CS_RS422(std::vector<std::uint8_t> process_data);
	~CS_RS422();

        enum class ParitySetting {
            NONE,
            ODD,
            EVEN
        };

        enum class DataBitsSetting {
            BITS_7,
            BITS_8
        };

        enum class StopBitsSetting {
            BITS_1,
            BITS_2
        };

	void BaudRate(unsigned int baud_rate);
	unsigned int BaudRate() const;
    void DataBits(DataBitsSetting data_bits);
    DataBitsSetting DataBits() const;        
    void Parity(ParitySetting parity);
    ParitySetting Parity() const;   
    void StopBits(StopBitsSetting stop_bits);
    StopBitsSetting StopBits() const;    

		const std::string& Ident() const;
  };
}

namespace iMS {
  %rename(Equals) IMSSystem::operator==;
  class IMSSystem
  {
  public:
    template<typename ... T>
    static std::shared_ptr<IMSSystem> Create(T&& ... t);
    void Connect();
    void Disconnect();
  	void SetTimeouts(int send_timeout_ms=500, int rx_timeout_ms=5000, int free_timeout_ms=30000, int discover_timeout_ms=2500);
    bool Open() const;
    const IMSController& Ctlr() const;
    const IMSSynthesiser& Synth() const;
    const std::string& ConnPort() const;
    bool operator==(IMSSystem const& rhs) const;
    bool ApplySettings(const IConnectionSettings& settings);
    //bool RetrieveSettings(IConnectionSettings& settings);  // ignored
    private:
        IMSSystem();
        IMSSystem(const std::shared_ptr<IConnectionManager>, const std::string&);
  };

  %extend IMSSystem {

        // Generic wrapper for C# to create and populate a concrete type
    CS_RS422* RetrieveSettings_RS422() {
        CS_RS422* obj = new CS_RS422();
        bool ok = $self->RetrieveSettings(*obj);
        if (!ok) {
            delete obj;
            return nullptr;
        }
        return obj;
    }

    CS_ETH* RetrieveSettings_ETH() {
        CS_ETH* obj = new CS_ETH();
        bool ok = $self->RetrieveSettings(*obj);
        if (!ok) {
            delete obj;
            return nullptr;
        }
        return obj;
    }
  }
}

