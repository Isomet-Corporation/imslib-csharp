using iMS;
using System;
using System.Reflection;

class Program
{
    static int Main()
    {
        try
        {
            Console.WriteLine("Initialising iMS Library...");

            iMSNET.Init();

            string nativeVersion = LibVersion.GetVersion();

            Console.WriteLine($"Native library version : {nativeVersion}");

            Assembly? asm = Assembly.GetAssembly(typeof(iMSNET)) ??
                throw new ArgumentException("Failed to get assembly version");
            
            Version asmVersion = asm.GetName().Version!;
            string managedVersion = asmVersion.ToString();

            Console.WriteLine($"Managed assembly version: {managedVersion}");

            if (!managedVersion.StartsWith(nativeVersion))
            {
                Console.Error.WriteLine("Version mismatch detected.");
                return 1;
            }

            Console.WriteLine("Version test passed.");
            return 0;
        }
        catch (Exception ex)
        {
            Console.Error.WriteLine("Test failed:");
            Console.Error.WriteLine(ex);
            return 1;
        }
    }
}
