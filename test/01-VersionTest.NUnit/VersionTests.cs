using NUnit.Framework;
using System;
using System.Reflection;
using iMS;

namespace VersionTests
{
    public class LibraryTests
    {
        [OneTimeSetUp]
        public void Init()
        {
            iMSNET.Init();
        }

        [Test]
        public void NativeLibraryVersionMatchesAssembly()
        {
            string nativeVersion = LibVersion.GetVersion();

            Assembly? asm = Assembly.GetAssembly(typeof(iMSNET)) ??
                throw new ArgumentException("Failed to get assembly version");
            
            Version asmVersion = asm.GetName().Version!;
            string managedVersion = asmVersion.ToString();

            TestContext.WriteLine($"Native version  : {nativeVersion}");
            TestContext.WriteLine($"Assembly version: {managedVersion}");

            Assert.That(managedVersion.StartsWith(nativeVersion),
                $"Version mismatch: native={nativeVersion} managed={managedVersion}");
        }
    }
}