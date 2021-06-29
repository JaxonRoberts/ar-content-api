using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Xamarin.Essentials;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace ARProject_Mobile.Views
{
	[XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class UploadPage : ContentPage
{
        public UploadPage()
        {
            InitializeComponent();
        }

        async void Button_Clicked(System.Object sender, System.EventArgs e)
        {
            var file = await MediaPicker.PickPhotoAsync();

            if (file == null)
                return;

            var content = new MultipartFormDataContent();
            content.Add(new StreamContent(await file.OpenReadAsync()), "file", file.FileName);

            var httpClient = new HttpClient();
            var response = await httpClient.PostAsync("", content);

            StatusLabel.Text = response.StatusCode.ToString();
        }
    }
}