// index.js
import puppeteer from 'puppeteer';

(async () => {
  console.log('正在启动 Chromium...');

  const browser = await puppeteer.launch({
    headless: 'new',
    executablePath: '/usr/bin/chromium-browser',
    args: [
      '--no-sandbox',
      '--disable-setuid-sandbox',
      '--disable-dev-shm-usage',
      '--single-process',
      '--no-zygote',
      '--disable-software-rasterizer',  
      '--disable-gpu',
      '--disable-features=VizDisplayCompositor',
    ],
    dumpio: false
  });

  try {
    console.log('浏览器启动成功，准备打开页面...');
    const page = await browser.newPage();
    
    await page.goto('https://time.yingming006.cn/', { 
      waitUntil: 'domcontentloaded', 
      timeout: 30000 
    });
    
    console.log('页面加载成功，标题：', await page.title());
    const dt=new Date().toISOString();
    await page.screenshot({ path: `${dt}-success.png` });
    console.log(`截图已保存：${dt}-success.png`);
    
  } catch (err) {
    console.error('出错了：', err.message);
  } finally {
    await browser.close();
    console.log('浏览器已关闭');
  }
})();
