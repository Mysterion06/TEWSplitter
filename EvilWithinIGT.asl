//Original Splitter by Mattmatt
//IGT by Mysterion_06_
//Startup Prompt, Text Components, & new start method added by Meta

state("EvilWithin")
{
    int chapter: 0x2133158;
    int InGame: 0x9A55EB0;
    int IGT: 0x9ACE548, 0x82040, 0xB4;
}

startup
{
    //Checks if the current time method is Real Time, if it is then it spawns a popup asking to switch to Game Time
    if (timer.CurrentTimingMethod == TimingMethod.RealTime)
    {
        var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time?",
            "LiveSplit | The Evil Within",
            MessageBoxButtons.YesNo,MessageBoxIcon.Question
        );

        if (timingMessage == DialogResult.Yes)
        {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }

    //creates text components for variable information
	vars.SetTextComponent = (Action<string, string>)((id, text) =>
	{
	        var textSettings = timer.Layout.Components.Where(x => x.GetType().Name == "TextComponent").Select(x => x.GetType().GetProperty("Settings").GetValue(x, null));
	        var textSetting = textSettings.FirstOrDefault(x => (x.GetType().GetProperty("Text1").GetValue(x, null) as string) == id);
	        if (textSetting == null)
	        {
	        var textComponentAssembly = Assembly.LoadFrom("Components\\LiveSplit.Text.dll");
	        var textComponent = Activator.CreateInstance(textComponentAssembly.GetType("LiveSplit.UI.Components.TextComponent"), timer);
	        timer.Layout.LayoutComponents.Add(new LiveSplit.UI.Components.LayoutComponent("LiveSplit.Text.dll", textComponent as LiveSplit.UI.Components.IComponent));
	
	        textSetting = textComponent.GetType().GetProperty("Settings", BindingFlags.Instance | BindingFlags.Public).GetValue(textComponent, null);
	        textSetting.GetType().GetProperty("Text1").SetValue(textSetting, id);
	        }
	
	        if (textSetting != null)
	        textSetting.GetType().GetProperty("Text2").SetValue(textSetting, text);
    });

    //Parent setting
	settings.Add("Variable Information", true, "Variable Information");
	//Child settings that will sit beneath Parent setting
    settings.Add("Chapter", true, "Current Chapter", "Variable Information");
    settings.Add("In-Game Time", false, "Current IGT", "Variable Information");
}

update
{
    //Prints current chapter
        if(settings["Chapter"]) 
    {
        vars.SetTextComponent("Chapter ",current.chapter.ToString());
    }
    //Prints IGT
            if(settings["In-Game Time"]) 
    {
        vars.SetTextComponent("In-Game Time",(TimeSpan.FromSeconds(current.IGT)).ToString());
    }

//DEBUG CODE
    //print("isLoading? " + current.loading.ToString());
}

start
{
    return current.chapter == 1 && current.IGT == 1;
}

split
{ 
    return
    (
        (old.chapter == 1 && current.chapter == 2) ||
        (old.chapter == 2 && current.chapter == 3) ||
        (old.chapter == 3 && current.chapter == 4) ||
        (old.chapter == 4 && current.chapter == 5) ||
        (old.chapter == 5 && current.chapter == 6) ||
        (old.chapter == 6 && current.chapter == 7) ||
        (old.chapter == 7 && current.chapter == 8) ||
        (old.chapter == 8 && current.chapter == 9) ||
        (old.chapter == 9 && current.chapter == 10) ||
        (old.chapter == 10 && current.chapter == 11) ||
        (old.chapter == 11 && current.chapter == 12) ||
        (old.chapter == 12 && current.chapter == 13) ||
        (old.chapter == 13 && current.chapter == 14) ||
        (old.chapter == 14 && current.chapter == 15)
    );
}

isLoading
{
    return true;
}

gameTime
{
    if(current.IGT > old.IGT && current.IGT != 0 && old.IGT != 0){
        return TimeSpan.FromSeconds(current.IGT);
    }
}
