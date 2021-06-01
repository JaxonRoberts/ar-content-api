using ARProject_Mobile.ViewModels;
using System.ComponentModel;
using Xamarin.Forms;

namespace ARProject_Mobile.Views
{
    public partial class ItemDetailPage : ContentPage
    {
        public ItemDetailPage()
        {
            InitializeComponent();
            BindingContext = new ItemDetailViewModel();
        }
    }
}