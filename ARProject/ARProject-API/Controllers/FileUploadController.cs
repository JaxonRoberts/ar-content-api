using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace ARProject_API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class FileUploadController : ControllerBase
    {
        private readonly ILogger<FileUploadController> _logger;
        private readonly IWebHostEnvironment _environment;
        public FileUploadController(ILogger<FileUploadController> logger,
            IWebHostEnvironment environment)
        {
            _logger = logger;
            _environment = environment ?? throw new ArgumentException(nameof(Environment));
        }

        [HttpPost]
        public async Task<IActionResult> Post()
        {
            try
            {
                var httpRequest = HttpContext.Request;

                if (httpRequest.Form.Files.Count > 0)
                {
                    foreach (var file in httpRequest.Form.Files)
                    {
                        var filePath = Path.Combine(_environment.ContentRootPath, "uploads");

                        if (!Directory.Exists(filePath))
                            Directory.CreateDirectory(filePath);

                        using (var memoryStream = new MemoryStream())
                        {
                            await file.CopyToAsync(memoryStream);
                            System.IO.File.WriteAllBytes(Path.Combine(filePath,
                                file.FileName), memoryStream.ToArray());
                        }

                        return Ok();
                    }
                }
            }

            catch (Exception e)
            {
                _logger.LogError(e, "Error");
                return new StatusCodeResult(500);
            }

            return BadRequest();
        }

        [HttpGet]
        public async Task<IActionResult> Get()
        {
            return Ok("FileUploadController: Get operation Success");
        }

    }
}
