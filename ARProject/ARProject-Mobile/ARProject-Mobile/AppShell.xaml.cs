﻿using ARProject_Mobile.ViewModels;
using ARProject_Mobile.Views;
using System;
using System.Collections.Generic;
using Xamarin.Forms;

namespace ARProject_Mobile
{
    public partial class AppShell : Xamarin.Forms.Shell
    {
        public AppShell()
        {
            InitializeComponent();
            Routing.RegisterRoute(nameof(ItemDetailPage), typeof(ItemDetailPage));
            Routing.RegisterRoute(nameof(NewItemPage), typeof(NewItemPage));
        }

    }
}
