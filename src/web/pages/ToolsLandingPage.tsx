import { Link } from 'react-router-dom';
import { HashLink } from 'react-router-hash-link';

function ToolsLanding() {
  return (
    <div>
      <h1>FinOps Toolkit - Available Tools</h1>
      <p>
        Welcome to the FinOps Toolkit. Explore the following tools to help manage and optimize your cloud costs.
      </p>
      <ul>
        <li><Link to="/hubs">🏦 FinOps Hubs – Open, extensible, and scalable cost reporting.</Link></li>
        <li><Link to="/bicep-registry">🦾 Bicep Registry Modules – Repository for Bicep modules.</Link></li>
        <li><Link to="/open-data">🌐 Open Data – Freely accessible data for cloud cost management.</Link></li>
        <li><Link to="/optimization-engine">🔍 Azure Optimization Engine – Extensible solution for optimization recommendations.</Link></li>
        <li><Link to="/power-bi">📊 Power BI Reports – Accelerate your reporting with Power BI starter kits.</Link></li>
        <li><Link to="/powershell">🖥️ PowerShell Module – Automate and manage FinOps solutions.</Link></li>
        <li><Link to="/workbooks">📒 FinOps Workbooks – Customizable home for engineers to maximize cloud ROI.</Link></li>
        <li><Link to="/workbooks/governance">📒 Governance Workbook – Central hub for governance.</Link></li>
        <li><Link to="/workbooks/optimization">📒 Optimization Workbook – Central hub for cost optimization.</Link></li>

        {/* OpenData Sections */}
        <li><HashLink to="/open-data#pricing-units">📏 Pricing Units – Microsoft pricing units and scaling factors.</HashLink></li>
        <li><HashLink to="/open-data#regions">🗺️ Regions – Microsoft Commerce locations and Azure regions.</HashLink></li>
        <li><HashLink to="/open-data#resource-types">📚 Resource Types – Azure resource types, display names, and icons.</HashLink></li>
        <li><HashLink to="/open-data#services">🎛️ Services – Microsoft consumed services, resource types, and FOCUS service categories.</HashLink></li>
        <li><HashLink to="/open-data#dataset-examples">⬇️ Sample Exports – Files from Cost Management exports.</HashLink></li>
      </ul>
    </div>
  );
};

export default ToolsLanding;
