using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

using Microsoft.AspNetCore.DataProtection;

namespace ARProject_API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProjectController : ControllerBase
    {
        private readonly ILogger<ProjectController> _logger;
        private readonly IWebHostEnvironment _environment;
        private readonly IDataProtector _protector;

        private int projectid;
        private string protectedProjectid;

        public ProjectController(ILogger<ProjectController> logger,
            IWebHostEnvironment environment,
            IDataProtectionProvider protectorProvider)
        {
            _logger = logger;
            _environment = environment ?? throw new ArgumentException(nameof(Environment));
            _protector = protectorProvider.CreateProtector("sharedKey");

            InitProject();
        }

        private void InitProject()
        {
            projectid = 42;
            protectedProjectid = _protector.Protect(projectid.ToString());
        }

        [HttpGet("get")]
        public async Task<IActionResult> Get()
        {
            var currentDate = DateTime.Now.ToLongDateString();
            var currentTime = DateTime.Now.ToLocalTime();

            return Ok($"ProjectController: Get operation Success - projectid: {projectid} - protectedProjectid: {protectedProjectid} - {currentDate} - {currentTime}");
        }

        [HttpGet("getunprotect")]
        public async Task<IActionResult> GetUnprotect()
        {
            var currentDate = DateTime.Now.ToLongDateString();
            var currentTime = DateTime.Now.ToLocalTime();

            string unProtectedProjectid = _protector.Unprotect(protectedProjectid);

            return Ok($"ProjectController: GetUnprotect operation Success - projectid: {unProtectedProjectid} - {currentDate} - {currentTime}");
        }

    }
}
