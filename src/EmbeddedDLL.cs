using System;
using System.Runtime.InteropServices;
using System.IO;
using System.Reflection;
using System.Runtime.CompilerServices;

namespace iMS
{
    internal static class NativeLoader
    {
        [DllImport("kernel32", SetLastError = true)]
        private static extern IntPtr LoadLibrary(string lpFileName);

        static NativeLoader()
        {
            LoadNativeDll();
        }

        private static void LoadNativeDll()
        {
            string resource = Environment.Is64BitProcess
                ? "iMSNETlib64"
                : "iMSNETlib32";

#if DEBUG
            string nativeDLL = "iMSNETlibd.dll";
#else
            string nativeDLL = "iMSNETlib.dll";
#endif

            var asm = Assembly.GetExecutingAssembly();

            using (var stream = asm.GetManifestResourceStream(resource))
            {
                if (stream == null)
                    throw new Exception("Missing embedded resource: " + resource);

                string dir = Path.Combine(
                    Path.GetTempPath(),
                    "iMSNET",
                    asm.GetName().Version.ToString());

                Directory.CreateDirectory(dir);

                string dllPath = Path.Combine(dir, nativeDLL);

                if (File.Exists(dllPath))
                {
                    File.Delete(dllPath);
                }
                using (var fs = new FileStream(dllPath, FileMode.Create, FileAccess.Write))
                    stream.CopyTo(fs);

                IntPtr handle = LoadLibrary(dllPath);

                if (handle == IntPtr.Zero)
                    throw new Exception("Failed to load native DLL: " + dllPath);
            }
        }
    }

    public static class iMSNET
    {        
        public static void Init()
        {
            // triggers static constructor
            var type = typeof(NativeLoader);
            RuntimeHelpers.RunClassConstructor(type.TypeHandle);
        }
    }

}