import { LightningElement,api,wire, track } from "lwc";
import pdflib from "@salesforce/resourceUrl/pdflib";
import { loadScript } from "lightning/platformResourceLoader";
import insertQuotesAttachement from '@salesforce/apex/RenderAsPDFControllerLWC.insertQuotesAttachement';

export default class CreatePDF extends LightningElement {
     debugger;
     @api recordId;
     contacts;
     renderedCallback() {
       loadScript(this, pdflib).then(() => { });
       
  }
     async createPdf() {
          debugger;

          insertQuotesAttachement({ recordId: this.recordId })
               .then((result) => {
                    this.contacts = result;
          })

    const pdfDoc = await PDFLib.PDFDocument.create();
    const timesRomanFont = await pdfDoc.embedFont(
      PDFLib.StandardFonts.TimesRoman
    );
       
       

    debugger;
    const page = pdfDoc.addPage();
    const { width, height } = page.getSize();
       const fontSize = 30;
       debugger;
    page.drawText("Learning with Salesforce Bolt !", {
      x: 50,
      y: height - 4 * fontSize,
      size: fontSize,
      font: timesRomanFont,
      color: PDFLib.rgb(0, 0.53, 0.71)
    });

    debugger;
    const pdfBytes = await pdfDoc.save();
    this.saveByteArray("My PDF", pdfBytes);
  }
  debugger;
     saveByteArray(pdfName, byte) {
          debugger;
    var blob = new Blob([byte], { type: "application/pdf" });
    var link = document.createElement("a");
    link.href = window.URL.createObjectURL(blob);
    var fileName = pdfName;
    link.download = fileName;
    link.click();
  }
}