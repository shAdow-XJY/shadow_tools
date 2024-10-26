<details>
<summary>1. web icon 格式</summary>
<div>
// need web/image_convert.js
// in index.html : <script src="image_convert.js"></script>

async function pngToIco(pngBytes) {
// 使用 Canvas 绘制 PNG 图像并生成 ICO 数据
const canvas = document.createElement('canvas');
const ctx = canvas.getContext('2d');

const imageBitmap = await createImageBitmap(new Blob([pngBytes], { type: 'image/png' }));
canvas.width = imageBitmap.width;
canvas.height = imageBitmap.height;
ctx.drawImage(imageBitmap, 0, 0);

// 导出 ICO 格式数据
return new Promise((resolve) => {
canvas.toBlob((blob) => {
const reader = new FileReader();
reader.onload = () => {
// 确保返回 ArrayBuffer
resolve(reader.result);
};
reader.readAsArrayBuffer(blob);
}, 'image/x-icon');
});
}

// 添加导出以便 Flutter 调用
window.pngToIco = pngToIco;

</div>
</details>
