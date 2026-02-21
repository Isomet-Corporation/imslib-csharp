namespace iMS {

  enum DownloadEvents {
    DOWNLOAD_FINISHED,
    DOWNLOAD_ERROR,
    VERIFY_SUCCESS,
    VERIFY_FAIL,
    DOWNLOAD_FAIL_MEMORY_FULL,
            DOWNLOAD_FAIL_TRANSFER_ABORT,
            IMAGE_DOWNLOAD_NEW_HANDLE
  };

  using ImageDownloadEvents = DownloadEvents;
  using SequenceDownloadEvents = DownloadEvents;
}

namespace iMS {

  class ImageDownload 
  {
  public:
    ImageDownload(std::shared_ptr<IMSSystem> ims, const Image& img);
    void SetFormat(const ImageFormat& fmt);
    bool StartDownload();
    bool StartVerify();
    int GetVerifyError();
    void ImageDownloadEventSubscribe(const int message, IEventHandler* handler);
    void ImageDownloadEventUnsubscribe(const int message, const IEventHandler* handler);
  };

}

namespace iMS {

  static enum ImagePlayerEvents {
    POINT_PROGRESS,
    IMAGE_STARTED,
    IMAGE_FINISHED
  };

}

//%include "ims_std_chrono.i"

namespace iMS {

  class ImagePlayer
  {
  public:
    enum class PointClock {
      INTERNAL,
	EXTERNAL
	};
    enum class ImageTrigger {
      POST_DELAY,
	EXTERNAL,
	HOST,
	CONTINUOUS
	};
    //    using Repeats = ImageRepeats;
//    enum class Polarity {
//      NORMAL,
//	INVERSE
//	};
    enum class StopStyle {
      GRACEFULLY,
	IMMEDIATELY
	};
    
    struct PlayConfiguration
    {
      PointClock int_ext{ PointClock::INTERNAL };
      ImageTrigger trig{ ImageTrigger::CONTINUOUS };
      ImageRepeats rpts{ ImageRepeats::NONE };
      int n_rpts{ 0 };
      Polarity clk_pol{ Polarity::NORMAL };
      Polarity trig_pol{ Polarity::NORMAL };
      
      std::chrono::duration < uint16_t, std::ratio<1, 10000> > del{ 0 };
      
      PlayConfiguration();
      PlayConfiguration(PointClock c);
      PlayConfiguration(PointClock c, ImageTrigger t);
      PlayConfiguration(PointClock c, const std::chrono::duration<int>& d);
      PlayConfiguration(PointClock c, const std::chrono::duration<int>& d, ImageRepeats r, int n_rpts);
      PlayConfiguration(ImageRepeats r);
      PlayConfiguration(ImageRepeats r, int n_rpts);
    } cfg;
    
    ImagePlayer(std::shared_ptr<IMSSystem> ims, const Image& img);
    ImagePlayer(std::shared_ptr<IMSSystem> ims, const Image& img, const PlayConfiguration& cfg);
    ImagePlayer(std::shared_ptr<IMSSystem> ims, const ImageTableEntry& ite, const kHz InternalClock);
    ImagePlayer(std::shared_ptr<IMSSystem> ims, const ImageTableEntry& ite, const int ExtClockDivide);
    ImagePlayer(std::shared_ptr<IMSSystem> ims, const ImageTableEntry& ite, const PlayConfiguration& cfg, const kHz InternalClock);
    ImagePlayer(std::shared_ptr<IMSSystem> ims, const ImageTableEntry& ite, const PlayConfiguration& cfg, const int ExtClockDivide);
    
    bool Play(ImageTrigger start_trig);
    inline bool Play();
    bool GetProgress();
    bool Stop(StopStyle stop);
    inline bool Stop();
    void SetPostDelay(const std::chrono::duration<double>& dly);
    
    void ImagePlayerEventSubscribe(const int message, IEventHandler* handler);
    void ImagePlayerEventUnsubscribe(const int message, const IEventHandler* handler);
  };
  
}

namespace iMS {
  
  %typemap(csinterfaces) ImageTableViewer "System.IDisposable, System.Collections.IEnumerable";
  class ImageTableViewer
  {
  %typemap(cscode) ImageTableViewer %{

  public bool IsFixedSize {
    get {
      return false;
    }
  }

  public bool IsReadOnly {
    get {
      return true;
    }
  }

  public ImageTableEntry this[int index]  {
    get {
      return getitemcopy(index);
    }
  }

  public int Count {
    get {
      return Entries();
    }
  }

  public bool IsSynchronized {
    get {
      return false;
    }
  }

  public void CopyTo(ImageTableEntry[] array)
  {
    CopyTo(0, array, 0, this.Count);
  }

  public void CopyTo(ImageTableEntry[] array, int arrayIndex)
  {
    CopyTo(0, array, arrayIndex, this.Count);
  }

  public void CopyTo(int index, ImageTableEntry[] array, int arrayIndex, int count)
  {
    if (array == null)
      throw new System.ArgumentNullException("array");
    if (index < 0)
      throw new System.ArgumentOutOfRangeException("index", "Value is less than zero");
    if (arrayIndex < 0)
      throw new System.ArgumentOutOfRangeException("arrayIndex", "Value is less than zero");
    if (count < 0)
      throw new System.ArgumentOutOfRangeException("count", "Value is less than zero");
    if (array.Rank > 1)
      throw new System.ArgumentException("Multi dimensional array.", "array");
    if (index+count > this.Count || arrayIndex+count > array.Length)
      throw new System.ArgumentException("Number of elements to copy is too large.");
    for (int i=0; i<count; i++)
      array.SetValue(getitemcopy(index+i), arrayIndex+i);
  }

  System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() {
    return new $csclassnameEnumerator(this);
  }

  public $csclassnameEnumerator GetEnumerator() {
    return new $csclassnameEnumerator(this);
  }

  // Type-safe enumerator
  /// Note that the IEnumerator documentation requires an InvalidOperationException to be thrown
  /// whenever the collection is modified. This has been done for changes in the size of the
  /// collection but not when one of the elements of the collection is modified as it is a bit
  /// tricky to detect unmanaged code that modifies the collection under our feet.
  public sealed class $csclassnameEnumerator : System.Collections.IEnumerator
    , System.Collections.Generic.IEnumerator<ImageTableEntry>
  {
    private $csclassname collectionRef;
    private int currentIndex;
    private object currentObject;
    private int currentSize;

    public $csclassnameEnumerator($csclassname collection) {
      collectionRef = collection;
      currentIndex = -1;
      currentObject = null;
      currentSize = collectionRef.Count;
    }

    // Type-safe iterator Current
    public ImageTableEntry Current {
      get {
        if (currentIndex == -1)
          throw new System.InvalidOperationException("Enumeration not started.");
        if (currentIndex > currentSize - 1)
          throw new System.InvalidOperationException("Enumeration finished.");
        if (currentObject == null)
          throw new System.InvalidOperationException("Collection modified.");
        return (ImageTableEntry)currentObject;
      }
    }

    private System.Collections.IEnumerator GetEnumerator()
    {
      return (System.Collections.IEnumerator)this;
    }
        
    // Type-unsafe IEnumerator.Current
    object System.Collections.IEnumerator.Current {
      get {
        return Current;
      }
    }

    public bool MoveNext() {
      int size = collectionRef.Count;
      bool moveOkay = (currentIndex+1 < size) && (size == currentSize);
      if (moveOkay) {
        currentIndex++;
        currentObject = collectionRef[currentIndex];
      } else {
        currentObject = null;
      }
      return moveOkay;
    }

    public void Reset() {
      currentIndex = -1;
      currentObject = null;
      if (collectionRef.Count != currentSize) {
        throw new System.InvalidOperationException("Collection modified.");
      }
    }

    public void Dispose() {
        currentIndex = -1;
        currentObject = null;
    }
  }
  %}

  public:
    %extend {
      ImageTableEntry getitemcopy(int index) throw (std::out_of_range) {
        if (index>=0 && index<$self->Entries())
          return (*$self)[index];
        else
          throw std::out_of_range("index");
      }
    }
    ImageTableViewer(std::shared_ptr<IMSSystem> ims);
    
    const int Entries() const;
    //const ImageTableEntry operator[](const std::size_t idx) const;
    bool Erase(const std::size_t idx);
    bool Erase(ImageTableEntry ite);
  };
  
}

namespace iMS {

  class SequenceDownload
  {
  public:
    SequenceDownload(std::shared_ptr<IMSSystem> ims, const ImageSequence& seq);
    
    bool Download(bool asynchronous = false);
    inline bool StartDownload();
    void SequenceDownloadEventSubscribe(const int message, IEventHandler* handler);
    void SequenceDownloadEventUnsubscribe(const int message, const IEventHandler* handler);
  };

}

namespace iMS {

  static enum SequenceEvents {
    SEQUENCE_START,
    SEQUENCE_FINISHED,
    SEQUENCE_ERROR,
    SEQUENCE_TONE,
    SEQUENCE_POSITION,
    Count
  };

}

namespace iMS {

  class SequenceManager
  {
  public:
    SequenceManager(std::shared_ptr<IMSSystem> ims);
    enum class PointClock {
      INTERNAL,
	EXTERNAL
	};
    enum class ImageTrigger {
      POST_DELAY,
	EXTERNAL,
	HOST,
	CONTINUOUS
	};
    //    using Repeats = ImageRepeats;


    struct  SeqConfiguration
    {
      PointClock int_ext{PointClock::INTERNAL };
      ImageTrigger trig{ ImageTrigger::CONTINUOUS };
      Polarity clk_pol{ Polarity::NORMAL };
      Polarity trig_pol{ Polarity::NORMAL };
      
      SeqConfiguration();
      SeqConfiguration(PointClock c);
      SeqConfiguration(PointClock c, ImageTrigger t);
    } cfg;
    
    bool StartSequenceQueue(const SeqConfiguration& cfg = SeqConfiguration(), ImageTrigger start_trig = ImageTrigger::CONTINUOUS);
    void SendHostTrigger();

    bool Stop(ImagePlayer::StopStyle style = ImagePlayer::StopStyle::GRACEFULLY);
    bool StopAtEndOfSequence();
    bool Pause(ImagePlayer::StopStyle style = ImagePlayer::StopStyle::GRACEFULLY);
    bool Resume();

    uint16_t QueueCount();
    bool GetSequenceUUID(int index, std::array<uint8_t, 16>& uuid);
    bool QueueClear();
    bool RemoveSequence(const ImageSequence& seq);
    bool RemoveSequence(const std::array<uint8_t, 16>& uuid);
    bool UpdateTermination(ImageSequence& seq, SequenceTermAction action, int val = 0);
    bool UpdateTermination(const std::array<uint8_t, 16>& uuid, SequenceTermAction action, int val = 0);
    bool UpdateTermination(ImageSequence& seq, SequenceTermAction action, const ImageSequence* term_seq);
    //    bool UpdateTermination(const std::array<std::uint8_t, 16>& uuid, SequenceTermAction term, const std::array<std::uint8_t, 16>& term_uuid);

    bool MoveSequence(const ImageSequence& dest, const ImageSequence& src);
    bool MoveSequenceToEnd(const ImageSequence& src);

    bool GetCurrentPosition();
    
    void SequenceEventSubscribe(const int message, IEventHandler* handler);
    void SequenceEventUnsubscribe(const int message, const IEventHandler* handler);
    
  };

}
