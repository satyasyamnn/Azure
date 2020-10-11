Configuration InstallIIS 
{
    Node 'localhost'
    {
        WindowsFeature IIS
        {
            Ensure = "Present"
            Name = "Web-Server"
        }
        WindowsFeature AspNet 
        {
            Ensure = "Present"
            Name = "Web-Asp-Net45"
        }
    }
}